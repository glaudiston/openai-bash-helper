#!/bin/bash
#
# You need to set your API token as:
# export OPENAI_API_KEY="your-token-here";
# You can use this file to set it:
source ${HOME}/.ssh/env;


function ask_openai() {
	text="$@";
	text_hash=$( echo -n "${text}" | md5sum <<<"$text" | cut -d " " -f1 );
	cache_dir="${HOME}/.openai/cache/${text_hash}";

	if [ -e "${cache_dir}/response" ]; then
	       cat "${cache_dir}/response";
	       echo "# INFO: Response cached at [${cache_dir}/response]" >&2;
	       exit 0;
	fi;
	mkdir -p "${cache_dir}";
	echo $?

	json_text_field="$( echo -n "${text}" | jq --raw-input --slurp )";
	wordcount=$(echo -n "${text}" | wc -w);
	tokens=$(( 4096 - ( wordcount +20 ) )); # we don't have an effective way to know the request tokens, it is the count after parsing and interpreted by the openai... so let's just pretend it will add 20 the input for now... 
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
		> "${cache_dir}/response" \
		2> "${cache_dir}/curl-stderr"
}

ask_openai "$@" | jq -r ".choices[].text"

