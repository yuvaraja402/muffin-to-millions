FROM public.ecr.aws/docker/library/python:3.12.9-slim

WORKDIR /app

COPY microservice/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY microservice/rates_api.py .

EXPOSE 5050

CMD ["python3", "rates_api.py"]