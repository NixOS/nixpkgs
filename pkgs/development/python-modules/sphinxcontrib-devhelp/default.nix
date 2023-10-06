{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, flit-core
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-devhelp";
  version = "1.0.5";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "sphinxcontrib_devhelp";
    inherit version;
    hash = "sha256-Y7QeDTggfKQOu+q89NjlH3bAPnjNYavhGM9ENcc9QhI=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  # Check is disabled due to circular dependency of sphinx
  doCheck = false;

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = with lib; {
    description = "sphinxcontrib-devhelp is a sphinx extension which outputs Devhelp document.";
    homepage = "https://github.com/sphinx-doc/sphinxcontrib-devhelp";
    license = licenses.bsd2;
    maintainers = teams.sphinx.members;
  };
}
