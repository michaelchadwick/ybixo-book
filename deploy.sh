#!/usr/bin/env bash

set -ex

mdbook build
aws s3 sync --delete book s3://www.ybixo.com
aws cloudfront create-invalidation --distribution-id E2UP1HR48BLT5N --paths '/*'
