from fastapi import APIRouter
from models.request_models import AIRequest
from services.ai_service import process_ai

router = APIRouter()

@router.post("/translate")
def translate(req: AIRequest):
    return process_ai("translate", req.input_text)

@router.post("/rephrase")
def rephrase(req: AIRequest):
    return process_ai("rephrase", req.input_text)

@router.post("/sentence")
def sentence(req: AIRequest):
    return process_ai("sentence", req.input_text)