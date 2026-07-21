#!/bin/sh
./build_hip/bin/llama-server --models-preset models.ini  --models-max 1 --host 0.0.0.0
