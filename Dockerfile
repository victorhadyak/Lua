# Use the OpenResty image as the base
FROM openresty/openresty:latest

# Copy your Lua script into the container
COPY /path/to/your/script.lua /opt/nginx/config/script.lua

# Modify nginx.conf to include the Lua script
RUN echo 'http {\n\
    lua_package_path "/opt/nginx/config/?.lua;;";  # Adjust the path as necessary\n\
    \n\
    server {\n\
        # ... other server configuration ...\n\
        \n\
        # Use the Lua script in a particular context, for example:\n\
        log_by_lua_file /opt/nginx/config/script.lua;\n\
    }\n\
}' >> /usr/local/openresty/nginx/conf/nginx.conf
RUN sed -i '0,/http {/s//lua_package_path "\/opt\/nginx\/config\/?.lua;;";\nhttp {/' /usr/local/openresty/nginx/conf/nginx.conf
RUN sed -i '/server {/a \    log_by_lua_file /opt/nginx/config/your_lua_script.lua;' /usr/local/openresty/nginx/conf/nginx.conf
# Add lua_package_path above the http block
RUN sed -i '0,/http {/s//lua_package_path "\/opt\/nginx\/config\/?.lua;;";\nhttp {/' /usr/local/openresty/nginx/conf/nginx.conf

# Add log_by_lua_file to a specific server block
RUN sed -i '/server_name yourserver.com;/a \    log_by_lua_file /opt/nginx/config/your_lua_script.lua;' /usr/local/openresty/nginx/conf/nginx.conf
# Mark the position after server_name nginxcon;
RUN sed -i '/server_name nginxcon;/a \# INSERT_LUA_HERE' /usr/local/openresty/nginx/conf/nginx.conf

# Add log_by_lua_file directive after the marker
RUN sed -i '/# INSERT_LUA_HERE/a \    log_by_lua_file /opt/nginx/config/your_lua_script.lua;' /usr/local/openresty/nginx/conf/nginx.conf
