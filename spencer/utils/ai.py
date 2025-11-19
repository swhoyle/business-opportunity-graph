import os
from dotenv import load_dotenv
from openai import OpenAI

load_dotenv()

openai_client = OpenAI(api_key = os.getenv("OPENAI_KEY"))