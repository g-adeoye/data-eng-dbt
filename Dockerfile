# syntax=docker/dockerfile:1

FROM python:3.13

COPY dbt_data_eng /app
COPY logs /app

RUN mkdir /root/.dbt
COPY profiles.yml /root/.dbt

COPY requirements.txt .
RUN pip install -r requirements.txt




