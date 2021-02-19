#!/bin/sh

d=$(cd $(dirname $0) && pwd)
cd $d/../

sudo npm update -g npm
sudo npm install -g webpack-dev-server
sudo npm install -g @vue/cli
if [ ! -f /usr/local/bin/vue ]; then
    # retry
    sudo npm install -g @vue/cli
fi
sudo npm install -g @vue/cli-init
sudo npm install -g vue vue-router bootstrap-vue bootstrap
sudo npm install -g vue-axios axios


pj_name="frontend"
rm -rf $pj_name
vue init webpack $pj_name
cd $pj_name

HOST=0.0.0.0 npm run dev
