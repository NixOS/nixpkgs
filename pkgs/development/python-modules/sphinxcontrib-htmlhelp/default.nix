{ lib
, buildPythonPackage
, fetchPypi
, isPy27
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-htmlhelp";
  version = "2.0.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f5f8bb2d0d629f398bf47d0d69c07bc13b65f75a81ad9e2f71a63d4b7a2f6db2";
  };

  # Check is disabled due to circular dependency of sphinx
  doCheck = false;

  meta = with lib; {
    description = "Sphinx extension which renders HTML help files";
    homepage = "https://github.com/sphinx-doc/sphinxcontrib-htmlhelp";
    license = licenses.bsd0;
    maintainers = teams.sphinx.members;
  };
}
