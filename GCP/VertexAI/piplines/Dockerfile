FROM gcr.io/deeplearning-platform-release/sklearn-cpu:latest

WORKDIR /root
COPY model_build.py /root/model_build.py

ENTRYPOINT ["python", "model_build.py"]