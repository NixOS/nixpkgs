{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  importlib-metadata,
  sphinx,
  pyenchant,
  setuptools,
  setuptools-scm,
  wheel,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-spelling";
  version = "8.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GZ0KFpAq2Aw4fClm3J6xD1ZbH7FczOFyEEAtt8JEPlw=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    sphinx
    pyenchant
  ] ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  # No tests included
  doCheck = false;

  pythonImportsCheck = [ "sphinxcontrib.spelling" ];

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = with lib; {
    description = "Sphinx spelling extension";
    homepage = "https://github.com/sphinx-contrib/spelling";
    changelog = "https://github.com/sphinx-contrib/spelling/blob/${version}/docs/source/history.rst";
    license = licenses.bsd2;
    maintainers = [ ];
  };
}
