# Use the official Dart image as a base
FROM dart:stable AS build-env

# Install required dependencies for Flutter
RUN apt-get update && \
    apt-get install -y git curl unzip xz-utils zip libglu1-mesa && \
    rm -rf /var/lib/apt/lists/*

# Set up Flutter
ENV FLUTTER_VERSION=3.19.6
RUN git clone https://github.com/flutter/flutter.git /flutter -b stable && \
    /flutter/bin/flutter --version
ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Enable web support
RUN flutter config --enable-web

# Set up app directory
WORKDIR /app
COPY . .

# Get dependencies
RUN flutter pub get

# Build web release
RUN flutter build web

# Use a minimal nginx image to serve the app
FROM nginx:alpine
COPY --from=build-env /app/build/web /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]