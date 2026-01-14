{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchNpmDeps,
  npmHooks,
  setuptools-scm,
  poetry-core,
  nodejs_18,
  sphinx,
  pydantic,
  pydantic-extra-types,
  appdirs,
}:

buildPythonPackage rec {
  pname = "sphinx-immaterial";
  version = "0.12.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jbms";
    repo = "sphinx-immaterial";
    rev = "v${version}";
    hash = "sha256-d+2xddIXithxMnypfQDqylJXKGMf4mgmN/eD8BPMpt8=";
  };

  build-system = [
    poetry-core
    setuptools-scm
  ];

  nativeBuildInputs = [
    nodejs_18
    npmHooks.npmConfigHook
  ];

  dependencies = [
    sphinx
    pydantic
    pydantic-extra-types
    appdirs
  ];

  env.npmDeps = fetchNpmDeps {
    name = "sphinx-immaterial-npm-deps";
    src = "${src}";
    hash = "sha256-NUKCAsn3Y9/gDkez5NgnCMKoQm45JSvR/oAepChDAJg=";
  };

  meta = {
    lib.description = "Adaptation of the popular mkdocs-material theme for the Sphinx documentation tool";
    lib.longDescription = ''
      This theme is regularly maintained to stay up to date with the upstream mkdocs-material repository.
      The HTML templates, JavaScript, and styles from the mkdocs-material theme are incorporated directly
      with mostly minor modifications.

      Independent of the upstream mkdocs-material theme, this theme integrates with and significantly
      extends Sphinx’s API documentation functionality.

      This theme is a fork of the sphinx-material theme, which proved the concept of a Sphinx theme based
      on an earlier version of the mkdocs-material theme, but has now significantly diverged from the
      upstream mkdocs-material repository.
    '';
    lib.homepage = "https://jbms.github.io/sphinx-immaterial/";
    lib.license = lib.licenses.mit;
    lib.maintainers = with lib.maintainers; [ jsqu4re ];
  };
}
