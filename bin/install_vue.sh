#!/bin/sh

d=$(cd $(dirname $0) && pwd)
cd $d/../frontend

npm install -save vue vue-router bootstrap-vue bootstrap
npm install --save axios vue-axios

npm install --save-dev prettier
npm install --save-dev eslint-plugin-prettier
npm install --save-dev @vue/eslint-config-prettier
