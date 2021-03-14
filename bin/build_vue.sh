#!/bin/sh
d=$(cd $(dirname $0)&& pwd)

cd $d/../frontend
export HOST=0.0.0.0

if [ "$1" = "dev" ]; then
    npm run dev
    exit $?
elif [ "$1" = "ci" ]; then
    rm -rf frontend/node_modules
    npm ci
    exit $?
fi

npm run build
exit $?
