FROM ubuntu

RUN apt-get update && apt-get install -y ca-certificates
COPY ./bin/alert-api /opt/alert-api
COPY ./private/soboon-service-account.json /opt/soboon-service-account.json
RUN chmod +x /opt/alert-api
WORKDIR /opt
CMD ["sh", "-c", "./alert-api"]