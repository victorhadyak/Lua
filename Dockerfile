# Start from the OpenResty base image
FROM openresty/openresty:alpine

# Install necessary packages
RUN apk add --no-cache --virtual .build-deps \
        git \
        build-base \
        lua5.1-dev \
        unzip \
        curl

# Install LuaRocks
RUN cd /tmp \
    && curl -fSL https://luarocks.org/releases/luarocks-3.8.0.tar.gz -o luarocks.tar.gz \
    && tar xzf luarocks.tar.gz \
    && cd luarocks-3.8.0 \
    && ./configure --prefix=/usr/local/openresty/luajit \
                   --with-lua=/usr/local/openresty/luajit \
                   --lua-suffix=jit-2.1.0-beta3 \
                   --with-lua-include=/usr/local/openresty/luajit/include/luajit-2.1 \
    && make build \
    && make install \
    && cd / \
    && rm -rf /tmp/luarocks-3.8.0 /tmp/luarocks.tar.gz

# Install any additional Lua dependencies using LuaRocks
RUN luarocks install lua-resty-http  # Example: installing lua-resty-http

# Clone the OpenTelemetry-Lua project
RUN git clone https://github.com/yangxikun/opentelemetry-lua.git /tmp/opentelemetry-lua

# Install the OpenTelemetry-Lua module using LuaRocks
RUN cd /tmp/opentelemetry-lua && luarocks make

# Clean up
RUN apk del .build-deps \
    && rm -rf /tmp/opentelemetry-lua
