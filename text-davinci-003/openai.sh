#!/bin/bash
#
# You need to set your API token as:
# export OPENAI_API_KEY="your-token-here";
# You can use this file to set it:
source ${HOME}/.ssh/env;

check_response() {
	input="$(cat)";
	cache_dir="$1"
	question="$2";
	if [ "${input}" == "" ]; then
		echo "ERROR: Empty response. deleting cache dir, and retry" >&2;
		rm -fr "${cache_dir}"
		ask_openai "${question}";
	fi;

	err=$(echo "${input}" | jq .error)
	if [ "${err}" != "null" ] ;then
		err_type="$(echo "$err" | jq .type)";
		err_message="$(echo "$err" | jq .message)"
		echo "ERROR: ${err_type}: ${err_message}. Retrying..." >&2;
		rm -fr "${cache_dir}"
		ask_openai "${question}";
	fi
	echo "${input}";
}

function ask_openai() {
	text="$@";
	text_hash=$( echo -n "${text}" | md5sum <<<"$text" | cut -d " " -f1 );
	cache_dir="${HOME}/.openai/cache/${text_hash}";

	if [ -e "${cache_dir}/response" ]; then
	       echo "# INFO: Response cached at [${cache_dir}/response]" >&2;
	       cat "${cache_dir}/response" | check_response "$cache_dir" "$text";
	       exit 0;
	fi;
	mkdir -p "${cache_dir}";

	json_text_field="$( echo -n "${text}" | jq --raw-input --slurp )";
	wordcount=$(echo -n "${text}" | wc -w);
	tokens=$(( 4096 - ( wordcount +100 ) )); # we don't have an effective way to know the request tokens, it is the count after parsing and interpreted by the openai... so let's just pretend it will add 20 the input for now... 
	echo -n '{
		"model": "text-davinci-003", 
		"prompt": '"${json_text_field}"', 
		"temperature": 0, 
		"max_tokens": '"${tokens}"'
	}' | jq > ${cache_dir}/request 

	curl https://api.openai.com/v1/completions \
		-H "Content-Type: application/json" \
		-H "Authorization: Bearer ${OPENAI_API_KEY}" \
		-d "@${cache_dir}/request" \
		2> "${cache_dir}/curl-stderr" \
		> "${cache_dir}/response";

	cat "${cache_dir}/response" | check_response "$cache_dir" "$text";

}

ask_openai "$@" | jq -r ".choices[].text"

