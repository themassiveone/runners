#!/bin/bash

# Maximum number of retries
max_retries=3

# Delay between retries in seconds
retry_delay=5

# Function to send curl request with retries
send_request_with_retry() {
    local retries=0
    local status_code=0

    while [[ $retries -lt $max_retries ]]; do
        # Send the curl request and capture the response
        response=$(curl --silent --show-error --location --request POST 'controlplane:8080/register')
        curl_exit_code=$?
        echo "executed curl request, response: $response"

        if [[ $curl_exit_code -ne 0 ]]; then
            echo "Curl failed with exit code $curl_exit_code. Retrying in $retry_delay seconds..."
            sleep $retry_delay
            retries=$((retries + 1))
            continue
        fi

        if [ $(echo "$response" | grep 'token') ]; then
            ./config.sh --url https://github.com/${GITHUB_ORG} --token $(echo "$response" | jq -r '.token')
            ./run.sh
            return 0
        else
            echo "Request failed. Retrying in $retry_delay seconds..."
            sleep $retry_delay
            retries=$((retries + 1))
        fi
    done

    echo "Request failed after $max_retries attempts"
    return 1
}

# Call the function to send the request
send_request_with_retry
