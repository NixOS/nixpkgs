{ lib
, buildPythonPackage
, fetchPypi
, isPy27
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-jsmath";
  version = "1.0.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "a9925e4a4587247ed2191a22df5f6970656cb8ca2bd6284309578f2153e0c4b8";
  };

  # Check is disabled due to circular dependency of sphinx
  doCheck = false;

  meta = with lib; {
    description = "sphinxcontrib-jsmath is a sphinx extension which renders display math in HTML via JavaScript.";
    homepage = "https://github.com/sphinx-doc/sphinxcontrib-jsmath";
    license = licenses.bsd0;
    maintainers = teams.sphinx.members;
  };
}
