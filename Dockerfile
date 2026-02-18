# -- Build Stage --
FROM golang:1.23 AS builder

WORKDIR /app

# Copy go.mod and go.sum to the workspace
COPY go.mod .
COPY main.go .
COPY templates ./templates

RUN go mod download

RUN CGO_ENABLED=0 go build -o app .

# -- Final Stage --
FROM scratch

WORKDIR /app

# Copy the built binary and templates from the builder stage
COPY --from=builder /app/app .
COPY --from=builder /app/templates ./templates

EXPOSE 8080

CMD ["./app"]
