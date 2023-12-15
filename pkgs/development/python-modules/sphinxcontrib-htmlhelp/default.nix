{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, flit-core
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-htmlhelp";
  version = "2.0.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "sphinxcontrib_htmlhelp";
    inherit version;
    hash = "sha256-bCahGKBbdgAHOEKbckoFaNveW3I5GmiFd9oI8RiRCSo=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  # Check is disabled due to circular dependency of sphinx
  doCheck = false;

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = with lib; {
    description = "Sphinx extension which renders HTML help files";
    homepage = "https://github.com/sphinx-doc/sphinxcontrib-htmlhelp";
    license = licenses.bsd2;
    maintainers = teams.sphinx.members;
  };
}
