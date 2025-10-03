# Use slim Python image
FROM python:3.10-slim

# Set workdir
WORKDIR /app

# Install system dependencies if needed (optional, uncomment if you face build issues)
# RUN apt-get update && apt-get install -y build-essential && rm -rf /var/lib/apt/lists/*

# Copy requirements and install
COPY Backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app and data
COPY Backend/app ./app
COPY Backend/data ./data

# Expose port
EXPOSE 8000

# Run FastAPI app
CMD ["sh", "-c", "uvicorn app.api:app --host 0.0.0.0 --port ${PORT:-8000}"]
