# vfox-pipenv

A [vfox](https://github.com/version-fox/vfox) plugin for [pipenv](https://pipenv.pypa.io/) - Python Development Workflow for Humans.

This plugin can also be used with [mise](https://mise.jdx.dev/) via the vfox backend.

## Requirements

- Python 3.7+ must be installed and available in PATH
- `curl` (for fetching version information)

## Installation

### With vfox

```bash
vfox add pipenv
```

### With mise

```bash
mise use vfox:pipenv@latest
```

## Usage

### List available versions

```bash
# vfox
vfox search pipenv

# mise
mise ls-remote vfox:pipenv
```

### Install a specific version

```bash
# vfox
vfox install pipenv@2024.0.1

# mise
mise install vfox:pipenv@2024.0.1
```

### Use a version globally

```bash
# vfox
vfox use -g pipenv@2024.0.1

# mise
mise use -g vfox:pipenv@2024.0.1
```

### Use a version in a project

```bash
# vfox
vfox use pipenv@2024.0.1

# mise
mise use vfox:pipenv@2024.0.1
```

## Automatic Virtualenv Activation (mise only)

When using this plugin with mise, you can configure automatic activation of your project's pipenv virtualenv. This means when you `cd` into a project directory with a `Pipfile`, the virtualenv will automatically be activated.

### Basic Setup

Add to your project's `mise.toml`:

```toml
[tools]
"vfox:pipenv" = "latest"
```

When you enter the project directory and a `Pipfile` exists with an associated virtualenv (created via `pipenv install`), mise will automatically:

1. Set `VIRTUAL_ENV` to the virtualenv path
2. Set `PIPENV_ACTIVE=1`
3. Add the virtualenv's `bin` directory to your `PATH`

### Custom Pipfile Location

If your `Pipfile` is in a non-standard location, specify it with the `pipfile` option:

```toml
[tools]
"vfox:pipenv" = { version = "latest", pipfile = "backend/Pipfile" }
```

### How It Works

The automatic activation uses mise's `exec-env` hook system:

1. When you enter a directory, mise checks for tool configurations
2. If pipenv is configured, the plugin runs `pipenv --venv` to find the virtualenv
3. If a virtualenv exists, environment variables are set to activate it
4. The pipenv binary is first in PATH, so project-level dependencies take precedence

## How It Works

This plugin installs pipenv by:

1. Creating a Python virtual environment at the installation path
2. Installing the specified pipenv version into that virtual environment using pip
3. Creating wrapper scripts that activate the virtual environment before running pipenv

This ensures each pipenv version is isolated and doesn't conflict with other Python packages.

## Important Notes

- **Python dependency**: Pipenv is installed using the Python interpreter available at installation time. If that Python interpreter is later removed, the installed pipenv version will stop working and needs to be reinstalled.
- **Pre-release versions**: Pre-release versions (alpha, beta, dev) are available and marked accordingly in the version list.
- **Virtualenv activation**: The automatic virtualenv activation only works when the virtualenv has been created (via `pipenv install`). If no virtualenv exists for the project, you'll need to run `pipenv install` first.

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Contributing

Issues and pull requests are welcome at https://github.com/mise-plugins/vfox-pipenv
