# Build stage - use Node Alpine just for Tailwind CLI
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Create a minimal package.json for Tailwind
RUN echo '{"devDependencies":{"tailwindcss":"^3.4.0"}}' > package.json

# Install Tailwind CSS
RUN npm install

# Copy config and source files
COPY tailwind.config.js .
COPY src/ ./src/

# Create dist directory and build
RUN mkdir -p dist/styles
RUN cp src/*.html dist/
RUN npx tailwindcss -i ./src/styles/input.css -o ./dist/styles/output.css --minify

# Production stage - pure nginx, no Node
FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy custom nginx config
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]