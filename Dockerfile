# Use Node.js as base image for building
FROM node:18-alpine as builder

# Set working directory
WORKDIR /app

# Copy package.json first (for better caching)
COPY package.json ./

# Install dependencies if any
RUN npm install || true

# Copy source files
COPY . .

# Make build script executable
RUN chmod +x scripts/build.bash

# Run the build script
RUN ./scripts/build.bash

# Use nginx to serve the static files
FROM nginx:alpine

# Copy built files from builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy nginx configuration (optional - nginx default works fine)
# COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
