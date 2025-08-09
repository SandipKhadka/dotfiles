local dap = require "dap"
local dapui = require "dapui"
local map = vim.keymap.set

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

map("n", "<leader>dc", dap.continue)
map("n", "<leader>dt", dap.terminate)
map("n", "<leader>so", dap.step_over)
map("n", "<leader>si", dap.step_into)
map("n", "<leader>sO", dap.step_out)
map("n", "<leader>db", dap.toggle_breakpoint)
map("n", "<leader>dB", function()
    dap.set_breakpoint(vim.fn.input "Breakpoint condition: ")
end)
map("n", "<leader>dr", dap.repl.open)
map("n", "<leader>dl", dap.run_last)

require("config.debug.python").setup()
