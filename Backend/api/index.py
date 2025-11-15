import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.api import app

# Vercel serverless function handler
def handler(request, context):
    return app
