# Credit Card Fraud Detection API

A machine learning API that predicts fraudulent credit card transactions in real time. Built with XGBoost and FastAPI, containerized with Docker, and deployed on Google Cloud Run.

## Live API

```
https://ml-model-deploy-525955513347.europe-west3.run.app
```

> Authentication required. Include a valid Bearer token in the `Authorization` header.

---

## Overview

This project trains an XGBoost classifier on credit card transaction data and serves predictions via a REST API. The model takes transaction features as input and returns a fraud/legitimate classification.

## Tech stack

- **Model** — XGBoost classifier
- **API** — FastAPI
- **Experiment tracking** — WandB + MLflow
- **Containerization** — Docker
- **Cloud** — Google Cloud Run (europe-west3)
- **CI/CD** — Auto-deploy on push via Cloud Build

---

## API reference

### `POST /predict/`

Predict whether a transaction is fraudulent.

**Request body**

```json
{
  "amt": 150.00,
  "hour": 14,
  "day_of_week": 2,
  "category": "grocery_pos",
  "state": "NY"
}
```

| Field | Type | Description |
|---|---|---|
| `amt` | float | Transaction amount in USD |
| `hour` | int | Hour of day (0–23) |
| `day_of_week` | int | Day of week (0=Monday, 6=Sunday) |
| `category` | string | Merchant category |
| `state` | string | US state code (e.g. `NY`) |

**Response**

```json
{
  "prediction": 0,
  "confidence": 0.97
}
```

`prediction`: `0` = legitimate, `1` = fraudulent

### `GET /health`

Returns service health status.

---

## Running locally

**1. Clone the repo**

```bash
git clone https://github.com/birukzenebe111/ml-model-deployment.git
cd ml-model-deployment
```

**2. Install dependencies**

```bash
pip install -r requirements.txt
```

**3. Set environment variables**

Create a `.env` file:

```env
WANDB_API_KEY=your_wandb_key
MLFLOW_TRACKING_URI=your_mlflow_uri
```

**4. Run the API**

```bash
uvicorn app:app --host 0.0.0.0 --port 8080 --reload
```

Visit `http://localhost:8080/docs` for the interactive Swagger UI.

---

## Running with Docker

```bash
docker build -t fraud-detection-api .
docker run -p 8080:8080 fraud-detection-api
```

---

## Deployment

This service is deployed on **Google Cloud Run** and automatically redeploys on every push to `main` via Cloud Build.

To deploy manually from Cloud Shell:

```bash
gcloud run deploy ml-model-deploy \
  --source . \
  --region europe-west3 \
  --no-allow-unauthenticated
```

---

## Project structure

```
ml-model-deployment/
├── app.py              # FastAPI application and prediction endpoint
├── Dockerfile          # Container configuration
├── requirements.txt    # Python dependencies
├── test_reqs.py        # Dependency tests
└── README-cloudshell.txt
```

---

## Calling the API (authenticated)

**Python**

```python
import requests
import subprocess

token = subprocess.check_output(
    ["gcloud", "auth", "print-identity-token"]
).decode().strip()

response = requests.post(
    "https://ml-model-deploy-525955513347.europe-west3.run.app/predict/",
    headers={"Authorization": f"Bearer {token}"},
    json={
        "amt": 150.00,
        "hour": 14,
        "day_of_week": 2,
        "category": "grocery_pos",
        "state": "NY"
    }
)
print(response.json())
```

**curl**

```bash
curl -X POST https://ml-model-deploy-525955513347.europe-west3.run.app/predict/ \
  -H "Authorization: Bearer $(gcloud auth print-identity-token)" \
  -H "Content-Type: application/json" \
  -d '{"amt": 150.00, "hour": 14, "day_of_week": 2, "category": "grocery_pos", "state": "NY"}'
```

---

## Author

Biruk Zenebe — [GitHub](https://github.com/birukzenebe111)
