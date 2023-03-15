FROM golang:alpine as builder
WORKDIR /build
ADD . .
RUN apk update && apk add --no-cache git ca-certificates && update-ca-certificates \
    && CGO_ENABLED=0 go build -ldflags='-w -s -extldflags "-static"' -a -o /build/gossm .

FROM alpine 
RUN apk update && apk add openssh
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /build/ /go/bin/
ENTRYPOINT [ "/go/bin/gossm" ]