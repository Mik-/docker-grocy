FROM lsiobase/nginx:3.11

# set version label
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="alex-phillips, homerr"

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache --virtual=build-dependencies \
	git \
	composer \
	yarn && \
 echo "**** install runtime packages ****" && \
 apk add --no-cache \
	curl \
	php7 \
	php7-gd \
	php7-pdo \
	php7-pdo_sqlite \
	php7-tokenizer && \
 echo "**** install grocy ****" && \
 cd /app && \
 git clone https://github.com/Mik-/grocy.git grocy && \
 cd /app/grocy && \
 git checkout scanner-enhancements && \
 cp -R /app/grocy/data/plugins \
	/defaults/plugins && \
 echo "**** install composer packages ****" && \
 composer install -d /app/grocy --no-dev && \
 echo "**** install yarn packages ****" && \
 cd /app/grocy && \
 yarn && \
 echo "**** cleanup ****" && \
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/root/.cache \
	/tmp/*

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 6781
VOLUME /config
