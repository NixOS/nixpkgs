{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, flit-core
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-applehelp";
  version = "1.0.8";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "sphinxcontrib_applehelp";
    inherit version;
    hash = "sha256-xApPlvN3bEOT2TNBIFOWL6wrhPTJmnmCukLglXanBhk=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  # Check is disabled due to circular dependency of sphinx
  dontCheckRuntimeDeps = true;
  doCheck = false;

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = with lib; {
    description = "sphinxcontrib-applehelp is a sphinx extension which outputs Apple help books";
    homepage = "https://github.com/sphinx-doc/sphinxcontrib-applehelp";
    license = licenses.bsd2;
    maintainers = teams.sphinx.members;
  };
}
