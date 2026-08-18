{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-devhelp";
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "sphinxcontrib_devhelp";
    inherit version;
    hash = "sha256-QR9dltRF0dc7tdUhMzd7QkjsedtceTzn2+WeB0tN0a0=";
  };

  nativeBuildInputs = [ flit-core ];

  # Check is disabled due to circular dependency of sphinx
  dontCheckRuntimeDeps = true;
  doCheck = false;

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = {
    description = "Sphinx extension which outputs Devhelp document";
    homepage = "https://github.com/sphinx-doc/sphinxcontrib-devhelp";
    license = lib.licenses.bsd2;
  };
}
