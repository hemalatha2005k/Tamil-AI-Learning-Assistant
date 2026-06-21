def build_prompt(task: str, text: str):

    if task == "translate":
        return f"""
You are a Tamil language expert.

Convert Tanglish to proper Tamil.

Rules:
- Only Tamil output
- No English
- Fix grammar
- Handle slang

Input: {text}
Output:
"""

    elif task == "rephrase":
        return f"""
You are a professional Tamil content writer.

Your task is to rewrite the given Tamil sentence into exactly 3 high-quality versions.

STRICT RULES:
- Output ONLY Tamil
- NO English words
- Each sentence must be complete (no fragments)
- Maintain original meaning
- Use natural, fluent, human-like Tamil
- Avoid repeating the same structure or wording
- Ensure each version feels unique in tone
- Do NOT generate very short or incomplete sentences
- Do NOT add explanations

STYLE REQUIREMENTS:
1. Version 1 → Simple and clear (common usage)
2. Version 2 → Slightly formal and refined
3. Version 3 → Polished and expressive (but still natural)

OUTPUT FORMAT (VERY IMPORTANT):
Return ONLY this JSON format:

{{
  "versions": [
    "sentence 1",
    "sentence 2",
    "sentence 3"
  ]
}}

- Ensure ALL 3 sentences are meaningful and complete
- Do NOT repeat the same sentence
- Do NOT use markdown or backticks

Input: {text}
Output:
"""

    elif task == "sentence":
        return f"""
You are a Tamil grammar expert.

Your task is to generate 3 correct Tamil sentences based on structured input.

STRICT RULES:
- Output ONLY Tamil
- NO English words
- Follow proper grammar
- Use correct tense and verb form
- Maintain natural sentence structure
- Do NOT add explanation

INPUT FORMAT:
The input will contain:
- Noun
- Verb
- Tense (past / present / future)
- Gender (optional)

OUTPUT REQUIREMENTS:
- Generate 3 different meaningful sentences
- All sentences must follow the given tense
- Slight variation in each sentence (time/place/context)

OUTPUT FORMAT (IMPORTANT):
Return ONLY this JSON:

{{
  "sentences": [
    "sentence 1",
    "sentence 2",
    "sentence 3"
  ]
}}

DO NOT use ``` or markdown.

Input: {text}
Output:
"""

    return text