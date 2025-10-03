# Use slim Python image
FROM python:3.10-slim

# Set workdir
WORKDIR /app

# Copy requirements and install
COPY Backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app
COPY Backend/app ./app

# Copy CSV file directly
COPY Backend/all_groundwater.csv .

# Run FastAPI app
CMD ["sh", "-c", "uvicorn app.api:app --host 0.0.0.0 --port $PORT"]
