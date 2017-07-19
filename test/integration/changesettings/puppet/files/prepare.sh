#!/usr/bin/env bash

# Install graylog-collector-sidecar fake binary

cp /tmp/kitchen/files/graylog-collector-sidecar /usr/bin
chmod +x /usr/bin/graylog-collector-sidecar

# Copy a fake configuration file

mkdir -p /etc/graylog/collector-sidecar/
cp /tmp/kitchen/files/collector_sidecar.yml /etc/graylog/collector-sidecar/