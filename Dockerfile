# Base image with Python and Debian Bookworm
FROM python:3.12-bookworm as base

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONFAULTHANDLER=1 \
    PIP_NO_CACHE_DIR=true \
    PIP_DEFAULT_TIMEOUT=100 \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    QR_CODE_DIR=/myapp/qr_codes

WORKDIR /myapp

# Update system and install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies in a virtual environment
COPY requirements.txt .
RUN python -m venv /.venv \
    && . /.venv/bin/activate \
    && pip install --upgrade pip \
    && pip install -r requirements.txt

# Final stage
FROM python:3.12-slim-bookworm as final

# Install runtime dependencies only (no libc-bin pinning)
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy virtual environment from base
COPY --from=base /.venv /.venv

# Set up environment
ENV PATH="/.venv/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    PYTHONFAULTHANDLER=1 \
    QR_CODE_DIR=/myapp/qr_codes

WORKDIR /myapp

# Use non-root user
RUN useradd -m myuser
USER myuser

# Copy project files with proper ownership
COPY --chown=myuser:myuser . .

# Expose FastAPI port
EXPOSE 8000

# Run the app
ENTRYPOINT ["uvicorn", "app.main:app", "--reload", "--host", "0.0.0.0", "--port", "8000"]
