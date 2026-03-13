FROM python:3.9

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# List installed packages and their versions
RUN pip list

# Try to import wandb and print version
RUN python -c "import wandb; print(wandb.__version__)" || echo "Failed to import wandb"

COPY . .

ENV WANDB_API_KEY=$WANDB_API_KEY
ENV WANDB_PROJECT=$WANDB_PROJECT

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8080"]
