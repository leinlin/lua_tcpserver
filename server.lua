
local socket = require("socket.core")


local clientList = {}
local clientNameList = {}

local function removeClient(client)
	local index = clientNameList[client]
	for k,v in ipairs(clientList) do
		if v == client then
			table.remove(clientList, k)
			clientNameList[client] = nil
			break;
		end
	end

	for k,v in pairs(clientNameList) do
		if v > index then
			clientNameList[k] = v - 1
		end
	end

end


-- 协程等待客户端连接
local function poll(server)
	local client = server:accept()
	if client then
		table.insert(clientList, client)
		clientNameList[client] = #clientList
		print("client connect")
	end

	local r,_ = socket.select(clientList, nil, 0)
	if #r > 0 then
		for _,c in ipairs(r) do
			local msg, err = c:receive()
			if not err then
				local ret = load(msg)()
				c:send(tostring(ret) .. "\n")
			elseif err == "closed" then
				print(clientNameList[c], "remove close client")
				removeClient(c)
			else
				print(err)
			end
		end
	end
end

local function listen(ip, port)
	local server = socket.tcp()

	-- 创建一个TCP服务器并监听指定端口
	server:settimeout(0)  -- 设置超时为0，防止阻塞
	server:bind(ip, port)
	server:listen()

	print("server listner")

	while true do
		poll(server)
		coroutine.yield()
	end
end

local function start(ip, port)
	local co = coroutine.create(function()
		listen(ip, port)
	end)

	return co
end

local function loop(co)
	coroutine.resume(co)
end

return
{
	start = start,
	loop = loop
}


