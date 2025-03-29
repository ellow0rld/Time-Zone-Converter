# Use official nginx image
FROM nginx:alpine

# Copy static files into the container
COPY . /usr/share/nginx/html

# Expose port 80
EXPOSE 80
