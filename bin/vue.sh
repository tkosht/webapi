#!/bin/sh

sudo npm install -g vue-cli
sudo npm install -g webpack-dev-server
sudo npm install -g vue bootstrap-vue bootstrap

pj_name="frontend"
rm -rf $pj_name
vue init webpack $pj_name
cd $pj_name
HOST=0.0.0.0 npm run dev
