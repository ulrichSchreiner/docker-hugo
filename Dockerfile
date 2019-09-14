FROM alpine:3.10
MAINTAINER Ulrich Schreiner <ulrich.schreiner@gmail.com>

# Download and install hugo
ENV HUGO_VERSION 0.58.2
ENV HUGO_BINARY hugo_${HUGO_VERSION}_Linux-64bit.tar.gz

RUN apk add --update \
        ca-certificates \
	curl \
        git \
	python \
	py-pygments \
        && rm -rf /var/cache/apk/* \
	&& curl -sSL https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY} | tar -xzC /usr/bin \
	&& chmod +x /usr/bin/hugo

# Create working directory
RUN mkdir /usr/share/blog
WORKDIR /usr/share/blog

# Expose default hugo port
EXPOSE 1313

# Automatically build site
ONBUILD ADD site/ /usr/share/blog

# By default, serve site
ENV HUGO_BASE_URL http://localhost:1313
CMD hugo server -b ${HUGO_BASE_URL} --bind=0.0.0.0 --appendPort=false --disableLiveReload
