FROM golang:1.24.3-alpine3.21 AS builder

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY internal ./internal
COPY pkg ./pkg
COPY main.go ./
RUN CGO_ENABLED=0 go build -trimpath -o /app/luna .

FROM alpine:3.21

WORKDIR /app
COPY --from=builder /app/luna .

EXPOSE 8080/tcp
ENTRYPOINT ["/app/luna", "--config", "/app/config/luna.yml"]
