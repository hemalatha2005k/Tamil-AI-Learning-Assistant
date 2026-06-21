from pydantic import BaseModel

class AIRequest(BaseModel):
    input_text: str