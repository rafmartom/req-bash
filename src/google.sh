#!/bin/bash 


##function build_gemini_payload() {
##    local prompt="$1"
##    local context="$2"
##    local input_code="$3"
##
##    local request_text="${prompt}"
##    [[ -n "${context}" ]] && request_text+=$'\n\nContext:\n'"${context}"
##    request_text+=$'\n\n'"${input_code}"
##
##    jq -n --arg text "${request_text}" \
##        '{contents: [{parts: [{text: $text}]}]}'
##}
##
##
##
##function get_gemini_url() {
##    local model="$1"
##    local api_key="$2"
##    echo "https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${api_key}"
##}


function google() {

    ###--------- JSON Payload
    JSON_PAYLOAD="$(jq -n \
        --arg prompt "${prompt}" \
        '{
            contents: [
                {
                    parts: [
                        { text: $prompt }
                    ]
                }
            ]
        }'
    )"


    URL="https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${GEMINI_API_KEY}"


#    CURL_CMD=(
#        curl -s -X POST
#        -H "Content-Type: application/json"
#        --data "${JSON_PAYLOAD}"
#        "${URL}"
#    )


    RESPONSE=$(curl -s -X POST -H "Content-Type: application/json" --data "${JSON_PAYLOAD}" "${URL}")
    echo "${RESPONSE}"

#    if [[ "${FULL_OUTPUT}" == "true" ]]; then
#        echo "${RESPONSE}"
#    else
#        echo "${RESPONSE}" | jq -r '.candidates[0].content.parts[0].text'
#    fi


}
