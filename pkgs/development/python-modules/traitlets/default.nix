{ lib
, buildPythonPackage
, fetchPypi
, glibcLocales
, pytest
, mock
, ipython_genutils
, decorator
, pythonOlder
, six
, hatchling
}:

buildPythonPackage rec {
  pname = "traitlets";
  version = "5.3.0";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-C7nx+fAXqo7Bh9ixsqemYmoqHYdxFrq6UqEpv6Ek+OI=";
  };

  nativeBuildInputs = [ hatchling ];
  checkInputs = [ glibcLocales pytest mock ];
  propagatedBuildInputs = [ ipython_genutils decorator six ];

  checkPhase = ''
    LC_ALL="en_US.UTF-8" py.test
  '';

  meta = {
    description = "Traitlets Python config system";
    homepage = "http://ipython.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
