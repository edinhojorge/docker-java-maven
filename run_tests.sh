#!/bin/sh

mvn \
    --batch-mode \
    --no-transfer-progress \
    --offline \
    clean compile test "${@}"