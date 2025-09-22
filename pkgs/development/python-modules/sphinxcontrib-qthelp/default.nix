{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  flit-core,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-qthelp";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "sphinxcontrib_qthelp";
    inherit version;
    hash = "sha256-T+fQrI/BcQRb5iOro+Ko9hP4aCcx+RU7suQOzha5u6s=";
  };

  nativeBuildInputs = [ flit-core ];

  # Check is disabled due to circular dependency of sphinx
  dontCheckRuntimeDeps = true;
  doCheck = false;

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = with lib; {
    description = "Sphinx extension which outputs QtHelp document";
    homepage = "https://github.com/sphinx-doc/sphinxcontrib-qthelp";
    license = licenses.bsd2;
    teams = [ teams.sphinx ];
  };
}
