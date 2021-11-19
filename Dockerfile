FROM python:3.9-alpine

LABEL maintainer="William Kokolis <william@kokolis.net>"

RUN addgroup pyrunner \
  && adduser -S -G pyrunner pyrunner \
  && apk add --no-cache curl libpq \
  && mkdir /app \
  && chown pyrunner.pyrunner /app 

WORKDIR /app

COPY . /app

RUN pip install -r requirements.txt \
  && chown -R pyrunner.pyrunner /app

USER pyrunner

EXPOSE 5000

HEALTHCHECK --interval=15s --timeout=5s CMD curl http://localhost:5000/v1/liveness || exit 1

CMD ["/usr/local/bin/gunicorn", "-b", "0.0.0.0:5000", "app:app"]
