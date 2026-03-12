FROM python:3.9

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# List installed packages and their versions
RUN pip list

# Try to import wandb and print version
RUN python -c "import wandb; print(wandb.__version__)" || echo "Failed to import wandb"

COPY . .

ENV WANDB_API_KEY=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
ENV WANDB_PROJECT=credit-card-fraud-detection-test-1

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8080"]