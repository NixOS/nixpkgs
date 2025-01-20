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
  version = "8.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8ER7ZBPHi2E7kWx4keNr6FoQXRkZyZeExT3+otj4BA8=";
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
