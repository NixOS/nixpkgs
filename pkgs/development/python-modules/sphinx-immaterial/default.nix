{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchNpmDeps
, npmHooks
, setuptools
, setuptools-scm
, poetry-core
, nodejs_18
, sphinx
, pydantic
, pydantic-extra-types
, appdirs
}:

buildPythonPackage rec {
  pname = "sphinx-immaterial";
  version = "0.11.11";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jbms";
    repo = "sphinx-immaterial";
    rev = "v${version}";
    sha256 = "sha256-Wcc3Bkp9i3L9gxNVZO/+8rvAGzH6I+XRO8kzbVYbT4k=";
  };

  propagatedBuildInputs = [
    sphinx
    pydantic
    pydantic-extra-types
    appdirs
  ];

  nativeBuildInputs = [
    setuptools
    poetry-core
    setuptools-scm
    nodejs_18
    npmHooks.npmConfigHook
  ];

  env.npmDeps = fetchNpmDeps {
    name = "sphinx-immaterial-npm-deps";
    src = "${src}";
    hash = "sha256-NUKCAsn3Y9/gDkez5NgnCMKoQm45JSvR/oAepChDAJg=";
  };

  meta = with lib; {
    description = "This theme is an adaptation of the popular mkdocs-material theme for the Sphinx documentation tool";
    longDescription = ''
      This theme is regularly maintained to stay up to date with the upstream mkdocs-material repository.
      The HTML templates, JavaScript, and styles from the mkdocs-material theme are incorporated directly
      with mostly minor modifications.

      Independent of the upstream mkdocs-material theme, this theme integrates with and significantly
      extends Sphinx’s API documentation functionality.

      This theme is a fork of the sphinx-material theme, which proved the concept of a Sphinx theme based
      on an earlier version of the mkdocs-material theme, but has now significantly diverged from the
      upstream mkdocs-material repository.
    '';
    homepage = "https://jbms.github.io/sphinx-immaterial/";
    license = licenses.mit;
    maintainers = with maintainers; [ jsqu4re ];
  };
}
