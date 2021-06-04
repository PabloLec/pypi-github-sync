FROM python:3.9-slim

RUN apt-get -y update
RUN apt-get -y install git curl jq

RUN pip install --upgrade --no-cache-dir pip-with-requires-python && \
    pip install --upgrade --no-cache-dir --prefer-binary setuptools wheel twine

WORKDIR /app

COPY entrypoint.sh .

RUN chmod +x entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]
