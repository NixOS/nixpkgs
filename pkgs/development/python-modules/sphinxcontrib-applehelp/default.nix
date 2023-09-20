{ lib
, buildPythonPackage
, fetchPypi
, isPy27
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-applehelp";
  version = "1.0.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "a072735ec80e7675e3f432fcae8610ecf509c5f1869d17e2eecff44389cdbc58";
  };

  # Check is disabled due to circular dependency of sphinx
  doCheck = false;

  meta = with lib; {
    description = "sphinxcontrib-applehelp is a sphinx extension which outputs Apple help books";
    homepage = "https://github.com/sphinx-doc/sphinxcontrib-applehelp";
    license = licenses.bsd0;
    maintainers = teams.sphinx.members;
  };
}
