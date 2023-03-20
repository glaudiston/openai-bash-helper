# chat-ai-proxy
This started as a bash interface to query openai API for AI responses. As other intersting alternatives born, I want it to be the central point to ask for multiple generative AI tools. Starting with openai and chatSonic(WriteSonic).

# How to use
create a file `${HOME}/.ssh/env` like:
```
export OPENAI_API_KEY="put-your-openai-api-here"
export WRITESONIC_API_KEY="put-your-writesonic-api-here"
```

then you can use it like:
```
ai-chat-council "whatever you want"
```

# wish list
I pretend to add features like:
```
-r, --reuse-context (default)
	Detect last context and try to keep it.
	OpenAI API does not provide such feature. ChatGPT is limited to web interface.
	ChatSonic does but it is limited to what we send in each request.
```

# using inside vim
Easy to integrate the openai chatbot to the bash shell and use it in vim.

Just a small script I’ve written to use openai bot inside vim… seems useful… very simple, but seems useful: https://github.com/glaudiston/openai-bash-helper


`:read !openai.sh write an bash function to detect internet connectivity`:

https://user-images.githubusercontent.com/8269938/206920411-596fa211-0c0c-45b0-ac05-9c938257852c.mov


`:read !openai.sh write a bash logger helper function that takes the first argument as message, then others arguments(as pairs, key and value) and output a structured json with time, pid, hostname, and all values expected to log.`:

https://user-images.githubusercontent.com/8269938/206922889-c558fa0e-fb43-407a-a712-e8a7a977f5e4.mov

