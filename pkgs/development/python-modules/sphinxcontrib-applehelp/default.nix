{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-applehelp";
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "sphinxcontrib_applehelp";
    inherit version;
    hash = "sha256-LynvMxc1zpWO+kc0hz8ISUGXCJTGCQQIsHnGGy4cBtE=";
  };

  nativeBuildInputs = [ flit-core ];

  # Check is disabled due to circular dependency of sphinx
  dontCheckRuntimeDeps = true;
  doCheck = false;

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = {
    description = "Sphinxcontrib-applehelp is a sphinx extension which outputs Apple help books";
    homepage = "https://github.com/sphinx-doc/sphinxcontrib-applehelp";
    license = lib.licenses.bsd2;
  };
}
