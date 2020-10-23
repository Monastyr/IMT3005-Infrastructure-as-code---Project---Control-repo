#!/bin/bash

count=$(ps -efwww | wc -l | tr -s ' ')
echo "process_count=$count"