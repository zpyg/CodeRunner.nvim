local api = vim.api
local fn = vim.fn
local cmd = vim.cmd

local CodeRunner = {}

function CodeRunner:setup(opts)
    self.config = require"code_runner.config":create(opts)
    return self
end
function CodeRunner:_new_buf()
    self.buf = api.nvim_create_buf(false, true)
    api.nvim_buf_set_option(self.buf, 'filetype', 'CodeRunner')
end
function CodeRunner:_new_win()
    local style = self.config.style
    self.win = api.nvim_open_win(self.buf, true, {
        relative = "editor",
        style = "minimal",
        border = style.border,
        width = style.layout.width,
        height = style.layout.height,
        col = style.layout.col,
        row = style.layout.row
    })
    api.nvim_win_set_option(self.win, "winhl", "Normal:"..style.bgcolor)
end
function CodeRunner:_new_term()
    self.term = fn.termopen(os.getenv("SHELL"))
    cmd("startinsert")
end
function CodeRunner:show()
    if self.buf == nil then
        self:_new_buf()
        self:_new_win()
        self:_new_term()
        api.nvim_chan_send(self.term, "clear\n")
    else
        self:_new_win()
    end
    api.nvim_set_current_win(self.win)
    cmd("startinsert")
end
function CodeRunner:hide()
    api.nvim_win_close(api.nvim_get_current_win(), {})
end
function CodeRunner:run()
    vim.cmd("write")
    local ftype = vim.bo.filetype
    local task = self.config.tasks[ftype]
    if type(task) == "function" then
        task()
        return
    end
    self:show()
    api.nvim_chan_send(self.term, task)
end

return CodeRunner
