FROM golang:1.11 as build
ADD . /go/src/github.com/kevlee1/m-lab-deployment-test/
RUN go get -v github.com/kevlee1/m-lab-deployment-test/

FROM ubuntu:latest

RUN useradd -ms /bin/bash plvp
RUN apt-get update && apt-get install -y \
    wget \
    build-essential \
&&  apt-get clean \
&&  rm -rf /var/lib/apt/lists/*

RUN mkdir -p scamper && cd scamper \
    && wget http://www.ccs.neu.edu/home/rhansen2/scamper.tar.gz \
    && tar xzf scamper.tar.gz && cd scamper-cvs-20150901 \
    && ./configure && make install

RUN useradd -ms /bin/bash plvp
USER plvp
WORKDIR /plvp
COPY --from=build /go/bin/plvp /plvp


ENTRYPOINT ["/plvp/plvp"]
CMD ["-loglevel", "error"]

EXPOSE 4381

