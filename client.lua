local socket = require("socket.core")

local sock, err = socket.tcp()

-- 模拟客户端连接
sock:connect("127.0.0.1", 5547)
sock:send("hello server")