#!/bin/sh
./build_hip/bin/llama-server --models-preset small_models.ini  --models-max 3 --host 0.0.0.0 --port 8088 &
./build_hip/bin/llama-server --models-preset models.ini  --models-max 1 --host 0.0.0.0 --port 8080

