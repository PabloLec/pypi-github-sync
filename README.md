# pypi-github-sync [![GitHub release (latest by date)](https://img.shields.io/github/v/release/pablolec/pypi-github-sync)](https://github.com/PabloLec/pypi-github-sync/releases/) [![GitHub](https://img.shields.io/github/license/pablolec/pypi-github-sync)](https://github.com/PabloLec/pypi-github-sync/blob/main/LICENCE) 

This action allows you to upload your Python package to PyPI automatically using latest GitHub version tag as release version.

## How does it work?

Running a Docker container, this action will clone your repo, fetch its latest release tag, modify `setup.py` and/or `pyproject.toml`, build and finally push to PyPI.

Also, with current procedure your GitHub repo remains untouched. That means the version parameter in your setup file will not be modified and its value does not matter.  
You can leave a dummy value, for example:
``` Python
setup(
    version="0.0.0",
    ...
)
```


## Usage

In your GitHub repo, create a workflow file or append to an existing one. (e.g. `.github/workflows/release.yml`)

Mandatory parameters are:
``` yaml
- name: pypi-github-sync
  uses: PabloLec/pypi-github-sync@v1.0.1
  with:
    github_repo: YOUR_USERNAME/YOUR_REPO
    twine_username: ${{ secrets.TWINE_USERNAME }}
    twine_password: ${{ secrets.TWINE_PASSWORD }}
```

You will need to change `YOUR_USERNAME` and `YOUR_REPO` values and set your PyPI username and password in your repository secrets ([See the docs for reference](https://docs.github.com/en/actions/reference/encrypted-secrets#creating-encrypted-secrets-for-a-repository)).

:arrow_right_hook: See [EXAMPLE.yml](EXAMPLE.yml) for a real world example.

## Inputs

#### `github_repo` *mandatory*

Your github repository with format `USERNAME/REPO` as in URLs. For example this repo is `PabloLec/pypi-github-sync`.

#### `twine_username` *mandatory*

Your PyPI username, add `TWINE_USERNAME` to your [repository secrets](https://docs.github.com/en/actions/reference/encrypted-secrets#creating-encrypted-secrets-for-a-repository).

#### `twine_password` *mandatory*

Your PyPI password, add `TWINE_PASSWORD` to your [repository secrets](https://docs.github.com/en/actions/reference/encrypted-secrets#creating-encrypted-secrets-for-a-repository).

#### `upload_repo` *optional*

The repository used for package uploading. Defaults to main PyPI repo, you can use others like PyPI test repo with `https://test.pypi.org/legacy/`.

#### `verify_metadata` *optional*

Verify build metadata before publication, defaults to false.

#### `skip_existing` *optional*

Do not raise an error if version already exists on repo, defaults to false.

#### `verbose` *optional*

Verbose output for twine upload, defaults to false.

## Contributing

Any contribution is welcome.  
To report a bug or offer your help, simply open a new [issue](https://github.com/PabloLec/pypi-github-sync/issues).  
You can also open an issue if you want a new feature to be implemented.
