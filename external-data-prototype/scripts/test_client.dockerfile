FROM golang:1.14.0 as development

ENV GO111MODULE=on CGO_ENABLED=0

RUN mkdir /edp
WORKDIR /edp

COPY go.mod /edp
RUN go mod download

COPY test-client /edp/test-client
RUN go build -o /output edp/test-client

FROM alpine:3.11 as release
COPY --from=development /output /test-client
ENTRYPOINT /test-client