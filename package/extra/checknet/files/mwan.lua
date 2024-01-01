#!/usr/bin/lua

local function get_get_params()
	local query_string = os.getenv("QUERY_STRING")
	if not query_string then
		return {}
	end

	local params = {}
	for key, value in query_string:gmatch("([^&=?]-)=([^&=?]+)") do
		params[key] = value
	end
	return params
end

local function execute_api_command(api_cmd)
	if api_cmd == "getmwan" then
		return io.popen("getmwan"):read("*a")
	else
		return '{"err":"Invalid API Command"}'
	end
end

local function mwan_main()
	local params = get_get_params()
	local api_cmd = params["api"]
	if api_cmd then
		local api_command_result = execute_api_command(api_cmd)
		io.write("Content-Type: text/plain\r\n\r\n")
		io.write(api_command_result)
	else
		io.write("Status: 400 Bad Request\r\n\r\n")
		io.write('{"err":"Missing API parameter"}')
	end
end

mwan_main()
