{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-devhelp";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ff7f1afa7b9642e7060379360a67e9c41e8f3121f2ce9164266f61b9f4b338e4";
  };

  # Check is disabled due to circular dependency of sphinx
  doCheck = false;

  meta = with lib; {
    description = "sphinxcontrib-devhelp is a sphinx extension which outputs Devhelp document.";
    homepage = "https://github.com/sphinx-doc/sphinxcontrib-devhelp";
    license = licenses.bsd0;
    maintainers = teams.sphinx.members;
  };
}
