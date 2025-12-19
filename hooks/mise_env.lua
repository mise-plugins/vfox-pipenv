--- MiseEnv hook for automatic pipenv virtualenv activation.
--- This hook is called by mise when setting up the environment.
--- It activates the pipenv virtualenv for the current project.
--- @param ctx table Context with options from mise.toml
--- @field ctx.options table Tool options including optional pipfile path
--- @return table Environment variables to set
function PLUGIN:MiseEnv(ctx)
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
            -- No Pipfile found, nothing to activate
            return {}
        end
    end

    -- Verify the Pipfile exists
    local f = io.open(pipfile_path, "r")
    if not f then
        -- Pipfile doesn't exist at specified path
        print("Warning: Pipfile not found at " .. pipfile_path)
        return {}
    end
    f:close()

    -- Get the directory containing the Pipfile for PIPENV_PIPFILE
    local pipfile_dir = pipfile_path:match("(.*/)")
    if not pipfile_dir then
        pipfile_dir = "./"
    end

    -- Run pipenv --venv to get the virtualenv path
    -- We need to set PIPENV_PIPFILE to ensure pipenv finds the right Pipfile
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
        -- No virtualenv found for this Pipfile
        -- This is normal if the user hasn't run `pipenv install` yet
        return {}
    end

    -- Verify the venv directory exists
    local venv_bin = venv_path .. "/bin"
    local test_file = io.open(venv_bin .. "/python", "r")
    if not test_file then
        -- Virtualenv bin directory doesn't exist
        print("Warning: Pipenv virtualenv exists but bin directory not found at " .. venv_bin)
        return {}
    end
    test_file:close()

    -- Return environment variables to activate the virtualenv
    return {
        {
            key = "VIRTUAL_ENV",
            value = venv_path,
        },
        {
            key = "PIPENV_ACTIVE",
            value = "1",
        },
        {
            key = "PATH",
            value = venv_bin,
        },
    }
end
