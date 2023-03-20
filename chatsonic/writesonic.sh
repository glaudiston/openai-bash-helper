#!/bin/bash
#

ask_chatsonic() {
	json_text_field="$( echo -n "$@" | jq --raw-input --slurp )";
	response="$(
curl -s --request POST \
     --url 'https://api.writesonic.com/v2/business/content/chatsonic?engine=premium&num_copies=1' \
     --header "X-API-KEY: ${WRITESONIC_API_KEY}" \
     --header 'accept: application/json' \
     --header 'content-type: application/json' \
     --data '
{
     "history_data": [
          {
               "message": "some contextual data",
               "is_sent": true
          }
     ],
     "input_text": '"${json_text_field}"',
     "enable_memory": true,
     "enable_google_results": true
}
')"
	echo "$response"
}
