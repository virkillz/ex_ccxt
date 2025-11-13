#! /bin/bash

cd ./js/source && \
# npm upgrade && \
cd ../.. && \

webpack-cli ./js/source/main.js  -o ./priv/js/dist/ --output-library-name ex_ccxt --output-library-type commonjs --target node

# webpack-cli ./js/source/main.js  -o ./priv/js/dist/main.js -p --output-library ex_ccxt --output-library-target commonjs --target node
