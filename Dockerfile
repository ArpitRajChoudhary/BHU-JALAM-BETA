# Use slim Python image
FROM python:3.10-slim

# Set workdir
WORKDIR /app

# Copy requirements and install
COPY Backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app code only
COPY Backend/app ./app

# Run FastAPI app
CMD ["sh", "-c", "uvicorn app.api:app --host 0.0.0.0 --port $PORT"]
