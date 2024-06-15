#!/bin/bash

# Maximum number of retries
max_retries=3

# Delay between retries in seconds
retry_delay=5

# URL to send the curl request to
url="http://control-plane:8080/request"

# Function to send curl request with retries
send_request_with_retry() {
    local retries=0
    local status_code=0

    while [[ $retries -lt $max_retries ]]; do
        # Send the curl request
        response=$(curl -s -o /dev/null -w "%{http_code}" $url)

        # Check the HTTP status code
        if [[ $response -eq 200 ]]; then
            echo "Request successful"
            return 0
        else
            echo "Request failed with status code $response. Retrying in $retry_delay seconds..."
            sleep $retry_delay
            retries=$((retries + 1))
        fi
    done

    echo "Request failed after $max_retries attempts"
    return 1
}

# Call the function to send the request
send_request_with_retry
