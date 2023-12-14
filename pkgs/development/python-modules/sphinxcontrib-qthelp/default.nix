{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, flit-core
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-qthelp";
  version = "1.0.6";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "sphinxcontrib_qthelp";
    inherit version;
    hash = "sha256-YrnRoYarf17jNW2Qb2SMrLemvblNIB7nrfJttVCSmC0=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  # Check is disabled due to circular dependency of sphinx
  doCheck = false;

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = with lib; {
    description = "sphinxcontrib-qthelp is a sphinx extension which outputs QtHelp document.";
    homepage = "https://github.com/sphinx-doc/sphinxcontrib-qthelp";
    license = licenses.bsd2;
    maintainers = teams.sphinx.members;
  };
}
