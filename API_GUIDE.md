# Hướng Dẫn Sử Dụng API Generate

## Tổng Quan
API `/api/generate` cho phép bạn gọi AI Agent để tạo nội dung dựa trên prompt của bạn.

## Endpoint
```
POST /api/generate
```

## URL Đầy Đủ
```
http://localhost:5005/api/generate
```
hoặc
```
http://YOUR_SERVER_IP:5005/api/generate
```

## Tham Số Request

### Bắt Buộc
| Tham số | Kiểu | Mô tả |
|---------|------|-------|
| `prompt` | string | Câu hỏi hoặc yêu cầu bạn muốn AI trả lời |

### Tùy Chọn
| Tham số | Kiểu | Mặc định | Mô tả |
|---------|------|----------|-------|
| `system_prompt` | string | null | Hướng dẫn hệ thống cho AI (vai trò, ngữ cảnh) |
| `model` | string | null | Model AI sử dụng: `gemini`, `custom-gemini`, `pollinations`, `mimo`, `llm7` |
| `temperature` | float | 0.7 | Độ sáng tạo (0.0 - 1.0). Càng cao càng sáng tạo |
| `max_tokens` | integer | 8000 | Số token tối đa trong response |

## Response Format

### Thành Công (200 OK)
```json
{
  "success": true,
  "result": "Nội dung AI trả về..."
}
```

### Lỗi (400/500)
```json
{
  "success": false,
  "error": "Mô tả lỗi"
}
```

## Ví Dụ Sử Dụng

### 1. Ví Dụ Cơ Bản (cURL)
```bash
curl -X POST http://localhost:5005/api/generate \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Viết một bài thơ ngắn về mùa xuân"
  }'
```

### 2. Với System Prompt (cURL)
```bash
curl -X POST http://localhost:5005/api/generate \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Giải thích về AI",
    "system_prompt": "Bạn là một giáo viên dạy công nghệ cho học sinh tiểu học. Hãy giải thích đơn giản và dễ hiểu."
  }'
```

### 3. Với Tất Cả Tham Số (cURL)
```bash
curl -X POST http://localhost:5005/api/generate \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Tạo một câu chuyện ngắn về robot",
    "system_prompt": "Bạn là một nhà văn khoa học viễn tưởng",
    "model": "gemini",
    "temperature": 0.9,
    "max_tokens": 5000
  }'
```

### 4. JavaScript/Fetch
```javascript
async function generateAI() {
  const response = await fetch('http://localhost:5005/api/generate', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      prompt: 'Viết một bài thơ về biển',
      system_prompt: 'Bạn là một nhà thơ lãng mạn',
      temperature: 0.8
    })
  });
  
  const data = await response.json();
  
  if (data.success) {
    console.log('Kết quả:', data.result);
  } else {
    console.error('Lỗi:', data.error);
  }
}

generateAI();
```

### 5. Python (requests)
```python
import requests
import json

url = 'http://localhost:5005/api/generate'
payload = {
    'prompt': 'Giải thích về machine learning',
    'system_prompt': 'Bạn là một chuyên gia AI',
    'model': 'gemini',
    'temperature': 0.7,
    'max_tokens': 3000
}

response = requests.post(url, json=payload)
data = response.json()

if data['success']:
    print('Kết quả:', data['result'])
else:
    print('Lỗi:', data['error'])
```

### 6. jQuery/AJAX
```javascript
$.ajax({
  url: 'http://localhost:5005/api/generate',
  type: 'POST',
  contentType: 'application/json',
  data: JSON.stringify({
    prompt: 'Tạo một công thức nấu ăn',
    system_prompt: 'Bạn là một đầu bếp chuyên nghiệp'
  }),
  success: function(data) {
    if (data.success) {
      console.log('Kết quả:', data.result);
    } else {
      console.error('Lỗi:', data.error);
    }
  },
  error: function(xhr, status, error) {
    console.error('Request failed:', error);
  }
});
```

### 7. PHP
```php
<?php
$url = 'http://localhost:5005/api/generate';
$data = array(
    'prompt' => 'Viết một câu chuyện cười',
    'system_prompt' => 'Bạn là một diễn viên hài',
    'temperature' => 0.9
);

$options = array(
    'http' => array(
        'header'  => "Content-Type: application/json\r\n",
        'method'  => 'POST',
        'content' => json_encode($data)
    )
);

$context  = stream_context_create($options);
$result = file_get_contents($url, false, $context);
$response = json_decode($result, true);

if ($response['success']) {
    echo "Kết quả: " . $response['result'];
} else {
    echo "Lỗi: " . $response['error'];
}
?>
```

## Các Model Hỗ Trợ

| Model | Mô tả |
|-------|-------|
| `gemini` | Google Gemini (mặc định) |
| `custom-gemini` | Gemini với cấu hình tùy chỉnh |
| `pollinations` | Pollinations AI |
| `mimo` | Mimo AI |
| `llm7` | LLM7 |

## Lưu Ý Quan Trọng

### Temperature
- **0.0 - 0.3**: Câu trả lời chính xác, ít sáng tạo (phù hợp cho câu hỏi kỹ thuật)
- **0.4 - 0.7**: Cân bằng giữa chính xác và sáng tạo (khuyến nghị)
- **0.8 - 1.0**: Rất sáng tạo, đa dạng (phù hợp cho văn học, nghệ thuật)

### Max Tokens
- Mỗi token ≈ 4 ký tự tiếng Anh hoặc 1-2 từ tiếng Việt
- 8000 tokens ≈ 6000-8000 từ tiếng Việt
- Giảm `max_tokens` để có response nhanh hơn

### System Prompt
System prompt giúp định hình vai trò và phong cách của AI:
- "Bạn là một chuyên gia marketing"
- "Bạn là một lập trình viên Python senior"
- "Bạn là một giáo viên dạy toán cho trẻ em"

## Xử Lý Lỗi

### Lỗi Thường Gặp

#### 400 Bad Request
```json
{
  "error": "Missing 'prompt' parameter"
}
```
**Giải pháp**: Đảm bảo bạn đã gửi tham số `prompt`

#### 500 Internal Server Error
```json
{
  "success": false,
  "error": "AI failed to generate a response"
}
```
**Giải pháp**: 
- Kiểm tra cấu hình AI Agent
- Kiểm tra API key (nếu sử dụng)
- Thử lại với model khác

## Test API

### Sử dụng Web Interface
Truy cập: `http://localhost:5005/test`

### Kiểm Tra API Đang Chạy
```bash
curl http://localhost:5005/
```

Response:
```json
{
  "status": "online",
  "message": "AI Agent Web API is running",
  "supported_models": ["gemini", "custom-gemini", "pollinations", "mimo", "llm7"],
  "endpoints": {
    "/api/generate": "POST - {prompt, system_prompt, model, temperature, max_tokens}",
    "/api/tts": "POST - {text, voice_id, rate, volume, engine}",
    "/api/voices": "GET - List available voices",
    "/test": "GET - TTS Web Interface"
  }
}
```

## Ví Dụ Thực Tế

### 1. Chatbot Đơn Giản
```javascript
class AIChatbot {
  constructor(apiUrl = 'http://localhost:5005/api/generate') {
    this.apiUrl = apiUrl;
    this.conversationHistory = [];
  }
  
  async chat(userMessage) {
    this.conversationHistory.push(`User: ${userMessage}`);
    
    const prompt = this.conversationHistory.join('\n') + '\nAI:';
    
    const response = await fetch(this.apiUrl, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        prompt: prompt,
        system_prompt: 'Bạn là một trợ lý AI thân thiện và hữu ích',
        temperature: 0.7
      })
    });
    
    const data = await response.json();
    
    if (data.success) {
      this.conversationHistory.push(`AI: ${data.result}`);
      return data.result;
    } else {
      throw new Error(data.error);
    }
  }
}

// Sử dụng
const bot = new AIChatbot();
const reply = await bot.chat('Xin chào!');
console.log(reply);
```

### 2. Content Generator
```python
import requests

class ContentGenerator:
    def __init__(self, api_url='http://localhost:5005/api/generate'):
        self.api_url = api_url
    
    def generate_blog_post(self, topic, tone='professional'):
        system_prompts = {
            'professional': 'Bạn là một blogger chuyên nghiệp',
            'casual': 'Bạn là một blogger thân thiện, gần gũi',
            'technical': 'Bạn là một chuyên gia kỹ thuật'
        }
        
        payload = {
            'prompt': f'Viết một bài blog về: {topic}',
            'system_prompt': system_prompts.get(tone, system_prompts['professional']),
            'temperature': 0.8,
            'max_tokens': 5000
        }
        
        response = requests.post(self.api_url, json=payload)
        data = response.json()
        
        if data['success']:
            return data['result']
        else:
            raise Exception(data['error'])

# Sử dụng
generator = ContentGenerator()
blog_post = generator.generate_blog_post('AI trong giáo dục', tone='professional')
print(blog_post)
```

### 3. Email Assistant
```javascript
async function generateEmail(recipient, purpose, tone = 'formal') {
  const systemPrompts = {
    formal: 'Bạn là một trợ lý viết email chuyên nghiệp',
    friendly: 'Bạn là một trợ lý viết email thân thiện',
    marketing: 'Bạn là một chuyên gia marketing email'
  };
  
  const response = await fetch('http://localhost:5005/api/generate', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      prompt: `Viết email gửi ${recipient} về ${purpose}`,
      system_prompt: systemPrompts[tone] || systemPrompts.formal,
      temperature: 0.6
    })
  });
  
  const data = await response.json();
  return data.success ? data.result : null;
}

// Sử dụng
const email = await generateEmail(
  'khách hàng', 
  'giới thiệu sản phẩm mới', 
  'marketing'
);
console.log(email);
```

## Bảo Mật

### CORS
API đã bật CORS, cho phép gọi từ mọi domain. Trong production, nên giới hạn:

```python
# Trong ai_api.py
from flask_cors import CORS

# Giới hạn domain
CORS(app, resources={r"/api/*": {"origins": ["https://yourdomain.com"]}})
```

### Rate Limiting
Nên thêm rate limiting để tránh abuse:

```python
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address

limiter = Limiter(
    app=app,
    key_func=get_remote_address,
    default_limits=["100 per hour"]
)

@app.route('/api/generate', methods=['POST'])
@limiter.limit("20 per minute")
def generate():
    # ...
```

## Troubleshooting

### API không phản hồi
```bash
# Kiểm tra service đang chạy
ps aux | grep ai_api

# Kiểm tra port
lsof -i :5005

# Xem log
tail -f /var/log/aiagent/api.log
```

### Timeout
Nếu request bị timeout, tăng timeout trong client:

```javascript
// Fetch với timeout
const controller = new AbortController();
const timeoutId = setTimeout(() => controller.abort(), 30000); // 30s

fetch(url, {
  signal: controller.signal,
  // ...
}).finally(() => clearTimeout(timeoutId));
```

## Liên Hệ & Hỗ Trợ

Nếu gặp vấn đề, kiểm tra:
1. Service đang chạy: `systemctl status aiagent`
2. Config file: `/etc/aiagent/config.json`
3. Log file: `/var/log/aiagent/`

---

**Phiên bản**: 1.0  
**Cập nhật**: 2025-12-29
