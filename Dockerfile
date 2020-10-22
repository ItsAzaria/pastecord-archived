FROM alpine:latest

# Update base and install required deps:
########################################
RUN apk update
RUN apk add nodejs nodejs-npm git procps bash redis

# Clone git repo & run installer:
#################################
RUN /bin/bash -l -c "cd / \
    && git clone https://github.com/seejohnrun/haste-server.git pastecord \
    && cd pastecord \
    && npm install"

# Expose default port:
######################
EXPOSE 7777

# Set CWD upon launch to hastebin-server
# install path:
########################################
WORKDIR /pastecord
RUN /bin/bash -l -c "rm -rf ./static \
    && rm -f ./about.md" 

# Copy configs into image:
##########################
COPY etc/config_local_redis.js /pastecord/config.js
COPY etc/redis_no_comments.conf /etc/redis.conf
COPY ./static/ static/

CMD redis-server /etc/redis.conf && npm start
