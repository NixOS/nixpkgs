{ lib
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-htmlhelp";
  version = "2.0.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DL3TAoFTMAWEIrmKETGVySSYJdaB4Y8R6LH3ii8R7/8=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  # Check is disabled due to circular dependency of sphinx
  doCheck = false;

  meta = with lib; {
    description = "Sphinx extension which renders HTML help files";
    homepage = "https://github.com/sphinx-doc/sphinxcontrib-htmlhelp";
    license = licenses.bsd0;
    maintainers = teams.sphinx.members;
  };
}
