local default = {
    -- 你可以在此处自定义不同语言的执行方式
    tasks = {
        c = "make", -- 可以是字符串，会发送到浮动终端执行
        python = "python <file>", -- 尖括号标记预定义变量。见下方变量。
        lua = function() -- 也可以执行一个函数
            vim.cmd("luafile %")
        end,
    },
    -- 此处可自定义浮动终端样式
    style = {
        -- 边框，见 `:help nvim_open_win`
        border = "rounded",
        -- 终端背景色
        bgcolor = "NONE",
        -- 终端大小和位置
        layout = {
            width = .8,
            height = .8,
            x = .5,
            y = .5
        }
    }
}

local Config = {}

function Config:create(opts)
    local tcopy = require("code_runner.util").tcopy
    if next(opts) == nil then
        self.config = tcopy(default)
    else
        self.config = tcopy(opts)
    end
    self:processLayout()
    self:processTasks()
    return self.config
end

function Config:processLayout()
    local cl = vim.o.columns
    local ln = vim.o.lines

    -- calculate our floating window size
    local width = math.ceil(cl * self.config.style.layout.width)
    local height = math.ceil(ln * self.config.style.layout.height - 4)

    -- and its starting position
    local col = math.ceil((cl - width) * self.config.style.layout.x)
    local row = math.ceil((ln - height) * self.config.style.layout.y - 1)

    self.config.style.layout = {
        width = width,
        height = height,
        col = col,
        row = row
    }
end

function Config:processTasks()
    local file = vim.fn.expand("%:l")
    for lang, task in pairs(self.config.tasks) do
        if type(task) == "string" then
            self.config.tasks[lang] = string.gsub(task, "<file>", file) .. '\n'
        end
    end
end

return Config
