# Stage 1: The Builder Stage
# We use a specific, recent Python version as mentioned in the report for a modern environment.
# Naming this stage 'builder' allows us to reference it later.
FROM python:3.11-slim-bookworm AS builder

# Set the working directory
WORKDIR /app

# Install build dependencies required for some Python packages.
# --no-install-recommends keeps the image lean.
RUN apt-get update && apt-get install -y --no-install-recommends build-essential

# Create a virtual environment. This isolates dependencies and avoids conflicts.
RUN python -m venv /opt/venv

# Activate the virtual environment for subsequent RUN commands
ENV PATH="/opt/venv/bin:$PATH"

# Copy the requirements file first to leverage Docker's layer caching.
COPY requirements.txt .

# Install the Python dependencies into the virtual environment.
# --no-cache-dir reduces the image size.
RUN pip install --no-cache-dir -r requirements.txt

# ---

# Stage 2: The Final Production Stage
# We start from a fresh, clean base image to keep it as small as possible.
FROM python:3.11-slim-bookworm

# Add labels for metadata, which is good practice for organization.
LABEL maintainer="Your Name <youremail@example.com>"
LABEL description="Production-ready Docker image for a Flask web application."

# Set the working directory
WORKDIR /app

# Create a non-root user and group for security purposes.
# Running as a non-root user is a critical security best practice.
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

# Copy the virtual environment with all installed dependencies from the builder stage.
COPY --from=builder /opt/venv /opt/venv

# Copy the application source code into the container.
COPY . .

# Change the ownership of the app directory to our non-root user.
RUN chown -R appuser:appgroup /app

# Switch to the non-root user.
USER appuser

# Expose port 5000 to the Docker network.
EXPOSE 5000

# Add a HEALTHCHECK to ensure the application is running correctly.
# Docker will periodically run this command inside the container.
# We need to install curl first.
USER root
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*
USER appuser
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:5000/ || exit 1

# Set the entrypoint to run the application using the python from our virtual environment.
# Using the JSON array format is the preferred syntax for CMD.
# The -u flag ensures that Python output is sent straight to the terminal without buffering.
CMD ["/opt/venv/bin/python", "-u", "app.py"]
