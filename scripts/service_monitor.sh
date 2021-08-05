#!/bin/bash

# Ben Soille <ben.soille@gmail.com>
#
# Checks the service status and sends correspondent
# value to CloudWatch custom metrics.
#
# Parameters: service name as per systemctl knows it
# 
# Service up - 1
# Service down - 0

set -eu

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <service to check>"
    exit 1
fi

SRVC=${1}

instance_id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
region_az=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)

if systemctl is-active --quiet ${SRVC}; then
    VALUE=1
else
    VALUE=0
fi

aws cloudwatch put-metric-data \
    --metric-name "${SRVC}-status" \
    --dimensions Instance=${instance_id}  \
    --namespace "Custom" \
    --region "${region_az%?}" \
    --value "${VALUE}"