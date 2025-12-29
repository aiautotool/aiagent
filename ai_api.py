from flask import Flask, request, jsonify, send_file
import sys
from ai_agent import AIAgent
import os
import json
import pyttsx3
import threading
import base64
import tempfile
import subprocess
from gtts import gTTS
from flask_cors import CORS

app = Flask(__name__)
CORS(app) # Enable CORS for all routes

# Load configuration
def load_config():
    config_paths = [
        'config.json',
        '/etc/aiagent/config.json',
        os.path.join(os.path.dirname(__file__), 'config.json')
    ]
    
    config = {
        "port": 5005,
        "host": "0.0.0.0",
        "debug": False
    }
    
    for path in config_paths:
        if os.path.exists(path):
            try:
                with open(path, 'r') as f:
                    loaded_config = json.load(f)
                    config.update(loaded_config)
                    print(f"Loaded config from {path}")
                    break
            except Exception as e:
                print(f"Error loading config from {path}: {e}")
    
    return config

config = load_config()

@app.route('/')
def index():
    # Serve the test HTML file directly from the index route
    test_page_path = os.path.join(os.path.dirname(__file__), 'test_tts.html')
    if os.path.exists(test_page_path):
        return send_file(test_page_path)
    
    return jsonify({
        "status": "online",
        "message": "AI Agent Web API is running",
        "supported_models": ["gemini", "custom-gemini", "pollinations", "mimo", "llm7"],
        "endpoints": {
            "/api/generate": "POST - {prompt, system_prompt, model, temperature, max_tokens}",
            "/api/tts": "POST - {text, voice_id, rate, volume, engine}",
            "/api/voices": "GET - List available voices",
            "/test": "GET - TTS Web Interface"
        }
    })

@app.route('/test')
def test_page():
    test_page_path = os.path.join(os.path.dirname(__file__), 'test_tts.html')
    return send_file(test_page_path)

@app.route('/api/voices', methods=['GET'])
def get_voices():
    try:
        engine = pyttsx3.init()
        voices = engine.getProperty('voices')
        voice_list = []
        for v in voices:
            voice_list.append({
                "id": v.id,
                "name": v.name,
                "languages": v.languages,
                "gender": v.gender
            })
        return jsonify({"success": True, "voices": voice_list})
    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500

@app.route('/api/tts', methods=['POST'])
def tts():
    data = request.get_json() or {}
    if not data:
        data = request.form.to_dict()

    text = data.get('text')
    voice_id = data.get('voice_id')
    rate = data.get('rate')
    volume = data.get('volume')
    engine_type = data.get('engine', 'native') # 'native' or 'gtts'

    if not text:
        return jsonify({"error": "Missing 'text' parameter"}), 400

    try:
        # Use appropriate suffix based on engine and platform
        if engine_type == 'gtts':
            suffix = '.mp3'
        else:
            suffix = '.m4a' if sys.platform == "darwin" else '.wav'
            
        with tempfile.NamedTemporaryFile(suffix=suffix, delete=False) as tmp_file:
            temp_filename = tmp_file.name

        if engine_type == 'gtts':
            print(f"Generating TTS using gTTS for: {text[:20]}...")
            # gTTS default is 'en', we should detect if we want 'vi'
            lang = 'vi' if any(ord(c) > 127 for c in text) else 'en'
            if voice_id and len(voice_id) <= 5: # e.g. 'vi', 'en-us'
                lang = voice_id
                
            tts_obj = gTTS(text=text, lang=lang)
            tts_obj.save(temp_filename)
        elif sys.platform == "darwin":
            cmd = ["say", "-o", temp_filename]
            
            # Voice
            if voice_id:
                # Extract voice name if it's a pyttsx3 ID
                v_name = voice_id.split('.')[-1] if '.' in voice_id else voice_id
                cmd.extend(["-v", v_name])
            else:
                cmd.extend(["-v", "Linh"]) # Default to Vietnamese Linh
                
            # Rate
            if rate:
                # 'say' rate is words per minute, 180-200 is normal
                cmd.extend(["-r", str(rate)])
            
            # Text to speak
            cmd.append(text)
            
            print(f"Running MacOS native TTS: {' '.join(cmd)}")
            subprocess.run(cmd, check=True)
        else:
            # Fallback for other OS (Linux/Windows)
            engine = pyttsx3.init()
            if voice_id:
                try:
                    print(f"Attempting to set voice to: {voice_id}")
                    engine.setProperty('voice', voice_id)
                except Exception as ve:
                    print(f"Warning: Failed to set voice {voice_id}: {ve}. Using default.")
            
            if rate:
                try:
                    engine.setProperty('rate', int(rate))
                except: pass
            if volume:
                try:
                    engine.setProperty('volume', float(volume))
                except: pass
            
            engine.save_to_file(text, temp_filename)
            engine.runAndWait()
            # Important: Re-initialize or close to release resources if needed
        
        # Check if file exists and has size
        if not os.path.exists(temp_filename) or os.path.getsize(temp_filename) == 0:
            raise Exception("Failed to generate audio file")

        # Read the file and encode to base64
        with open(temp_filename, 'rb') as audio_file:
            audio_data = audio_file.read()
            
        # Detect format
        mime_type = "audio/wav"
        file_format = "wav"
        
        if audio_data.startswith(b'FORM'):
            mime_type = "audio/aiff"
            file_format = "aiff"
        elif audio_data.startswith(b'RIFF'):
            mime_type = "audio/wav"
            file_format = "wav"
        elif b'ftypM4A' in audio_data[:20] or b'ftypmp42' in audio_data[:20]:
            mime_type = "audio/mp4"
            file_format = "m4a"
        elif audio_data.startswith(b'\xff\xfb') or audio_data.startswith(b'ID3'):
            mime_type = "audio/mpeg"
            file_format = "mp3"

        base64_audio = base64.b64encode(audio_data).decode('utf-8')
        print(f"Success! Format: {file_format}, Size: {len(audio_data)} bytes")
        sys.stdout.flush()
        
        # Clean up
        if os.path.exists(temp_filename):
            os.remove(temp_filename)
            
        return jsonify({
            "success": True,
            "audio_base64": base64_audio,
            "format": file_format,
            "mime_type": mime_type
        })
        
    except Exception as e:
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500

@app.route('/api/generate', methods=['POST'])
def generate():
    data = request.get_json() or {}
    
    # Fallback to form data if JSON is empty
    if not data:
        data = request.form.to_dict()

    prompt = data.get('prompt')
    if not prompt:
        return jsonify({"error": "Missing 'prompt' parameter"}), 400

    system_prompt = data.get('system_prompt')
    model = data.get('model')
    temperature = float(data.get('temperature', 0.7))
    max_tokens = int(data.get('max_tokens', 8000))

    try:
        result = AIAgent.call_ai_agent(
            prompt=prompt, 
            system_prompt=system_prompt, 
            model=model,
            temperature=temperature,
            max_tokens=max_tokens
        )
        
        if result:
            return jsonify({
                "success": True,
                "result": result
            })
        else:
            return jsonify({
                "success": False,
                "error": "AI failed to generate a response"
            }), 500
            
    except Exception as e:
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500

if __name__ == '__main__':
    port = int(os.environ.get('PORT', config.get('port', 5005)))
    host = config.get('host', '0.0.0.0')
    debug = config.get('debug', False)
    
    print(f"Starting AI API Server on {host}:{port}...")
    app.run(host=host, port=port, debug=debug)

