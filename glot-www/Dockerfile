FROM ubuntu:20.04

RUN apt update && apt install -y libpq-dev && apt install -y ca-certificates
ADD glot-www/release/glot-www.tar.gz /

WORKDIR /glot-www
ENTRYPOINT [ "/glot-www/glot" ]