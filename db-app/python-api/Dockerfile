FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

RUN apt-get update && apt-get install -y curl

RUN useradd -m appuser

RUN chown -R appuser:appuser /app

USER appuser

EXPOSE 5000

CMD python app.py
