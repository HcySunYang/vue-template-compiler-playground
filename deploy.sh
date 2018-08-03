#!/usr/bin/env sh

set -e

yarn run build

cd ./dist

git init
git config user.name 'HcySunYang'
git config user.email 'HcySunYang@outlook.com'
git add -A
git commit -m 'deploy'

git push -f git@github.com:HcySunYang/vue-template-compiler-playground.git master:gh-pages

cd -