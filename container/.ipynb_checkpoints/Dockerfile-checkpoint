# Build an image that can do training and inference in SageMaker

FROM 763104351884.dkr.ecr.us-west-2.amazonaws.com/tensorflow-training:1.14.0-cpu-py36-ubuntu16.04

RUN apt-get update && \
    apt-get install -y nginx imagemagick graphviz

RUN pip install --upgrade pip
RUN pip install gevent gunicorn flask tensorflow_hub seqeval graphviz nltk spacy tqdm
RUN python -m spacy download en_core_web_sm
RUN python -m spacy download en

ENV PATH="/opt/program:${PATH}"

# Set up the program in the image
COPY sagemaker_keras_text_classification /opt/program
WORKDIR /opt/program