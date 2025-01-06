FROM public.ecr.aws/lambda/python:3.9.2024.11.22.15
#FROM python:3.9-slim-bullseye

ARG DEBIAN_FRONTEND=noninteractive

# install lib required for pyaudio
RUN apt update && apt install -y portaudio19-dev && apt-get clean && rm -rf /var/lib/apt/lists/*
#RUN apk update && apk add --no-cache portaudio-dev

# update pip to support for whl.metadata -> less downloading

# create a working directory
RUN mkdir /app
WORKDIR /app

# install pytorch, but without the nvidia-libs that are only necessary for gpu

# install the requirements for running the whisper-live server
COPY requirements/server.txt /app/
RUN pip install --no-cache-dir -U "pip>=24" 
RUN pip install --no-cache-dir torch --index-url https://download.pytorch.org/whl/cpu 
RUN pip install --no-cache-dir  -r server.txt && rm server.txt

COPY whisper_live /app/whisper_live
COPY run_server.py /app

CMD ["python", "run_server.py"]
