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
  version = "4.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d023ee369ddd2763310e4c3eae1ff649689440d4ae59d7485eb4cfbbe3e359f7";
  };

  checkInputs = [ glibcLocales pytest mock ];
  propagatedBuildInputs = [ ipython_genutils decorator six ] ++ lib.optional (pythonOlder "3.4") enum34;

  checkPhase = ''
    LC_ALL="en_US.UTF-8" py.test
  '';

#   doCheck = false;

  meta = {
    description = "Traitlets Python config system";
    homepage = http://ipython.org/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}