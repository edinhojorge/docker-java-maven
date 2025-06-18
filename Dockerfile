FROM maven:3.9.9-eclipse-temurin-17-alpine@sha256:c1b318f88ab1bcf7aae3e0fceff4f5890fe6f7c910ead1c538bd5cada01df6c6 AS builder

WORKDIR /app

# Copy POM first to leverage Docker cache for dependencies
COPY pom.xml ./

# Download all dependencies and plugins at once
# This ensures everything needed for offline mode is cached
RUN mvn \
    --batch-mode \
    --no-transfer-progress \
    dependency:go-offline \
    dependency:resolve-plugins \
    dependency:resolve \
    dependency:sources \
    clean compile test-compile \
    -DskipTests=true

# Copy source code
COPY src ./src

# Run compilation and tests in offline mode
RUN mvn \
    --batch-mode \
    --no-transfer-progress \
    --offline \
    clean compile test

COPY run_tests.sh ./

# Keep the compiled classes and dependencies available
CMD ["sh"]