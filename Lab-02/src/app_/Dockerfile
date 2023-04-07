FROM python:3.9.2
WORKDIR /app
COPY requirements.txt /app
RUN pip install -r requirements.txt
COPY . .
EXPOSE 8000
CMD ["python3", "./app.py"]

