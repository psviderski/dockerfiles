FROM --platform=linux/arm64 alpine:3.19

ARG MINER_ARTIFACT="https://github.com/h9-dev/chia-miner/releases/download/v2.0.0/H9-Miner-chia-og-v2.0.0-1-linux.zip"

# Create 'app' user without a password to use instead of root.
RUN adduser -u 1001 -D app -h /app

USER app
RUN wget -O /tmp/miner.zip ${MINER_ARTIFACT} \
    && unzip /tmp/miner.zip -d /app \
    && mv /app/linux/h9-miner-chia-linux-aarch64 /app/ \
    && rm -rf /app/linux \
    && rm /tmp/miner.zip

CMD ["/app/h9-miner-chia-linux-aarch64"]
