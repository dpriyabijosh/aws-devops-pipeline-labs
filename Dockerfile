# Step 1: Specify the base image (Pinning minor version ensures production predictability)
FROM alpine:3.20

# Step 2: Set the working directory inside the container
WORKDIR /app

# Step 3: Install packages using Alpine's package manager (apk)
# Added bash, grep, gawk, and dos2unix to support your script
RUN apk update && apk add --no-cache curl bash grep gawk dos2unix

# Step 4: Copy your existing script into the container filesystem
COPY scripts/log-parser.sh scripts/log-parser.sh

# Step 4: Copy your existing script into the container filesystem
COPY server.log server.log

# Step 5: Sanitize file line-endings and grant explicit execution permissions
RUN dos2unix /app/scripts/log-parser.sh && chmod +x /app/scripts/log-parser.sh

# Step 6: Define execution entrypoint using the absolute system binary path
CMD ["/bin/bash", "/app/scripts/log-parser.sh", "/app/server.log"]