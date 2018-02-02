FROM google/cloud-sdk:170.0.1-slim

COPY hail_submit.py /hail_submit.py
COPY src /src/*

RUN pip install --upgrade google-api-python-client
RUN pip install google-cloud-storage google-auth-httplib2

ENV PYTHONPATH=$PYTHONPATH:/
