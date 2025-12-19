# vfox-pipenv

A [vfox](https://github.com/version-fox/vfox) plugin for [pipenv](https://pipenv.pypa.io/) - Python Development Workflow for Humans.

This plugin can also be used with [mise](https://mise.jdx.dev/) via the vfox backend.

## Requirements

- Python 3.7+ must be installed and available in PATH

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

## Automatic Virtualenv Activation

When you have pipenv configured and enter a directory containing a `Pipfile`, the plugin automatically activates the project's virtualenv (if it exists). This sets:

1. `VIRTUAL_ENV` to the virtualenv path
2. `PIPENV_ACTIVE=1`
3. Adds the virtualenv's `bin` directory to your `PATH`

**Note:** The virtualenv must already exist (created via `pipenv install`).

## How It Works

This plugin installs pipenv by:

1. Creating a Python virtual environment at the installation path
2. Installing the specified pipenv version into that virtual environment using pip
3. Creating wrapper scripts that activate the virtual environment before running pipenv

This ensures each pipenv version is isolated and doesn't conflict with other Python packages.

## Important Notes

- **Python dependency**: Pipenv is installed using the Python interpreter available at installation time. If that Python interpreter is later removed, the installed pipenv version will stop working and needs to be reinstalled.
- **Pre-release versions**: Pre-release versions (alpha, beta, dev) are available and marked accordingly in the version list.

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Contributing

Issues and pull requests are welcome at https://github.com/mise-plugins/vfox-pipenv
