local runner = require("code_runner.runner")

local Wrapper = {}

function Wrapper.setup(opts)
    runner:setup(opts)
end

function Wrapper.run()
    runner:run()
end

function Wrapper.show()
    runner:show()
end

function Wrapper.hide()
    runner:hide()
end

return Wrapper
