# Start from the OpenResty base image
FROM openresty/openresty:alpine

# Install necessary packages and LuaRocks
RUN apk add --no-cache --virtual .build-deps \
        git \
        build-base \
        lua5.1-dev \
    && luarocks install lua-resty-http  # Install any additional dependencies

# Clone the OpenTelemetry-Lua project
RUN git clone https://github.com/yangxikun/opentelemetry-lua.git /tmp/opentelemetry-lua

# Install the OpenTelemetry-Lua module using LuaRocks
RUN cd /tmp/opentelemetry-lua && luarocks make

# Clean up
RUN apk del .build-deps \
    && rm -rf /tmp/opentelemetry-lua

# Copy your Nginx configuration files
# Assuming you have your nginx.conf and any other necessary files in a directory called "nginx"
COPY nginx /etc/nginx/

# Set the working directory
WORKDIR /usr/local/openresty/nginx

# Expose the port Nginx is listening on
EXPOSE 80

# Start Nginx
CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]

