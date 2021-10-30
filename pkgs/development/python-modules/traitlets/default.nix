{ lib
, buildPythonPackage
, fetchPypi
, glibcLocales
, pytest
, mock
, ipython_genutils
, decorator
, enum34
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "traitlets";
  version = "5.1.0";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bd382d7ea181fbbcce157c133db9a829ce06edffe097bcf3ab945b435452b46d";
  };

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
