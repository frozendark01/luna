FROM golang:1.24-alpine AS builder

# Instalăm unelte de bază
RUN apk add --no-cache git

WORKDIR /app

# Copiem modulele și descărcăm dependențele externe
COPY go.mod go.sum ./
RUN go mod download

# Copiem restul codului sursă
COPY . .

# Verificăm dacă fișierele sunt unde trebuie (va apărea în log-ul de build)
RUN ls -R internal/luna/

# Compilăm specificând clar că vrem să construim din fișierul main.go
# Folosim -mod=mod pentru a permite Go să rezolve căile interne
RUN CGO_ENABLED=0 go build -mod=mod -o luna main.go

FROM alpine:3.21
RUN apk add --no-cache ca-certificates
WORKDIR /app
COPY --from=builder /app/luna /app/luna

ENTRYPOINT ["/app/luna"]
