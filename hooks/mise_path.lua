--- MisePath hook for automatic pipenv virtualenv PATH setup.
--- This hook is called by mise when setting up PATH.
--- It adds the pipenv virtualenv bin directory to PATH.
--- @param ctx table Context with options from mise.toml
--- @field ctx.options table Tool options including optional pipfile path
--- @return table Path entries to add
function PLUGIN:MisePath(ctx)
    local options = ctx.options or {}

    -- Get pipfile path from options, or look in current directory
    local pipfile_path = options.pipfile

    -- If pipfile option is provided, use it; otherwise look for Pipfile in current dir
    if not pipfile_path then
        -- Check if Pipfile exists in current directory
        local f = io.open("Pipfile", "r")
        if f then
            f:close()
            pipfile_path = "Pipfile"
        else
            -- No Pipfile found, nothing to add to PATH
            return {}
        end
    end

    -- Verify the Pipfile exists
    local f = io.open(pipfile_path, "r")
    if not f then
        return {}
    end
    f:close()

    -- Run pipenv --venv to get the virtualenv path
    local cmd = "PIPENV_PIPFILE=\"" .. pipfile_path .. "\" pipenv --venv 2>/dev/null"
    local handle = io.popen(cmd)
    if not handle then
        return {}
    end
    local venv_path = handle:read("*a")
    handle:close()

    -- Trim whitespace
    venv_path = venv_path:match("^%s*(.-)%s*$")

    if not venv_path or venv_path == "" then
        return {}
    end

    -- Verify the venv directory exists
    local venv_bin = venv_path .. "/bin"
    local test_file = io.open(venv_bin .. "/python", "r")
    if not test_file then
        return {}
    end
    test_file:close()

    -- Return path entries
    return { venv_bin }
end
