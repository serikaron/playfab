FROM golang:1.14.0 as development

ENV GO111MODULE=on CGO_ENABLED=0

RUN mkdir /edp
WORKDIR /edp

COPY go.mod /edp
RUN go mod download

COPY external-server /edp/external-server
RUN go build -o /output edp/external-server

FROM alpine:3.11 as release
COPY --from=development /output /ext-server
ENTRYPOINT /ext-server