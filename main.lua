local server = require("server")

-- 使用协程的示例
local co = server.start("*", 5548)
local loop = server.loop

local function mainLoop()
    loop(co)
end

while true do
    mainLoop()
end