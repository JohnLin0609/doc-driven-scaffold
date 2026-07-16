# Backend image for {{PROJECT_NAME}}. Adjust the base image and install step to your stack.
FROM {{BASE_IMAGE}}

WORKDIR /app

# Dependencies first (better layer caching).
COPY {{DEPS_FILE}} ./
RUN {{INSTALL_COMMAND}}

# Application source.
COPY src/ ./src/

EXPOSE 8000
CMD [{{START_COMMAND}}]
