#!/bin/bash
cd /home/ubuntu/prod-
rm -rf node_modules build package-lock.json
npm install
npm run build
