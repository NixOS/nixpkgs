{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  flit-core,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-applehelp";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

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

<<<<<<< HEAD
  meta = {
    description = "Sphinxcontrib-applehelp is a sphinx extension which outputs Apple help books";
    homepage = "https://github.com/sphinx-doc/sphinxcontrib-applehelp";
    license = lib.licenses.bsd2;
=======
  meta = with lib; {
    description = "Sphinxcontrib-applehelp is a sphinx extension which outputs Apple help books";
    homepage = "https://github.com/sphinx-doc/sphinxcontrib-applehelp";
    license = licenses.bsd2;
    teams = [ teams.sphinx ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
