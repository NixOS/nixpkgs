{ lib
, buildPythonPackage
, fetchPypi
, isPy27
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-qthelp";
  version = "1.0.3";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "4c33767ee058b70dba89a6fc5c1892c0d57a54be67ddd3e7875a18d14cba5a72";
  };

  # Check is disabled due to circular dependency of sphinx
  doCheck = false;

  meta = with lib; {
    description = "sphinxcontrib-qthelp is a sphinx extension which outputs QtHelp document.";
    homepage = "https://github.com/sphinx-doc/sphinxcontrib-qthelp";
    license = licenses.bsd0;
    maintainers = teams.sphinx.members;
  };
}
