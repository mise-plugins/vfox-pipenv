--- Each SDK may have different environment variable configurations.
--- This allows plugins to define custom environment variables (including PATH settings)
--- @param ctx table Context information
--- @field ctx.path string SDK installation directory
function PLUGIN:EnvKeys(ctx)
    local version_path = ctx.path

    if RUNTIME.osType == "windows" then
        return {
            {
                key = "PATH",
                value = version_path .. "\\wrapper_bin"
            },
        }
    else
        return {
            {
                key = "PATH",
                value = version_path .. "/wrapper_bin"
            },
        }
    end
end
