local M = {}

function M.setup()
    local dap = require "dap"

    -- Use debugpy installed by Mason (recommended)
    local mason_path = vim.fn.stdpath "data"
    local debugpy_path = mason_path .. "/mason/packages/debugpy/venv/bin/python"

    dap.adapters.python = function(cb, config)
        if config.request == "attach" then
            local port = (config.connect or config).port
            local host = (config.connect or config).host or "127.0.0.1"
            assert(port, "`connect.port` is required for attach")

            cb {
                type = "server",
                port = port,
                host = host,
                options = { source_filetype = "python" },
            }
        else
            cb {
                type = "executable",
                command = debugpy_path, -- debugpy installed by Mason
                args = { "-m", "debugpy.adapter" },
                options = { source_filetype = "python" },
            }
        end
    end

    dap.configurations.python = {
        {
            type = "python",
            request = "launch",
            name = "Launch File",
            program = "${file}",
            pythonPath = function()
                local venv = os.getenv "VIRTUAL_ENV"
                if venv then
                    return venv .. "/bin/python"
                else
                    return "python"
                end
            end,
        },
        {
            type = "python",
            request = "attach",
            name = "Attach to Process",
            connect = {
                host = "127.0.0.1",
                port = 5678,
            },
            mode = "remote",
        },
    }
end

return M
