FROM python:3
COPY ./app /app
COPY requirements.txt /app
WORKDIR /app
RUN pip install -r requirements.txt
EXPOSE 8000
ENTRYPOINT [ "python" ]
CMD [ "app.py" ]
