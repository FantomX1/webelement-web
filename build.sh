#!/bin/bash

rm -rf _build && mkdir -p _build

if [[ ! `docker ps --all | grep "webelement-data"` ]]; then
  docker run --name webelement-data webelement/data:latest chown -R `id -u`:`id -g` /data/node_modules /data/bower_components
fi

docker run -u `id -u` --volumes-from webelement-data --rm -v "$PWD:/data" -w /data webelement/website:latest sh -c 'bower install && npm install && gulp clean && JEKYLL_ENV=production gulp jekyll && gulp copy-app-images && gulp css && gulp fonts && gulp copy-site-files && gulp copy-site-html-and-minify && gulp revreplace'

tar -czf _build.tar.gz _build && rm -rf _build
