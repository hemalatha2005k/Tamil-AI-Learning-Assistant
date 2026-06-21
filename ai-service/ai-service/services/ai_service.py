import requests
import json
import re
from utils.prompt_builder import build_prompt

OLLAMA_URL = "http://localhost:11434/api/generate"
MODEL = "gemma4:e2b"

def process_ai(task: str, text: str):

    prompt = build_prompt(task, text)

    response = requests.post(
        OLLAMA_URL,
        json={
            "model": MODEL,
            "prompt": prompt,
            "stream": False
        }
    )

    data = response.json()
    raw = data.get("response", "").strip()

    raw = re.sub(r"```json", "", raw)
    raw = re.sub(r"```", "", raw)

    match = re.search(r"\{.*\}", raw, re.DOTALL)
    if match:
        raw = match.group(0)

    try:
        parsed = json.loads(raw)
        return parsed
    except:
        return {"result": raw}