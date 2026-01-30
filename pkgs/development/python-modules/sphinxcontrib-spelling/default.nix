{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  sphinx,
  pyenchant,
  setuptools,
  setuptools-scm,
  wheel,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-spelling";
  version = "8.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sphinx-contrib";
    repo = "spelling";
    tag = version;
    hash = "sha256-gN+FkgIzk7wG/ni+DzaeiePjCiK9k7Jrn2IUDgy8DOg=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    sphinx
    pyenchant
  ];

  # No tests included
  doCheck = false;

  pythonImportsCheck = [ "sphinxcontrib.spelling" ];

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = {
    description = "Sphinx spelling extension";
    homepage = "https://github.com/sphinx-contrib/spelling";
    changelog = "https://github.com/sphinx-contrib/spelling/blob/${version}/docs/source/history.rst";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
