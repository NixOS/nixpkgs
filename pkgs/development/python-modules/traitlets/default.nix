{ lib
, buildPythonPackage
, fetchPypi

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
  version = "4.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9c4bd2d267b7153df9152698efb1050a5d84982d3384a37b2c1f7723ba3e7835";
  };

  checkInputs = [  pytest mock ];
  propagatedBuildInputs = [ ipython_genutils decorator six ] ++ lib.optional (pythonOlder "3.4") enum34;

  checkPhase = ''
  '';

#   doCheck = false;

  meta = {
    description = "Traitlets Python config system";
    homepage = http://ipython.org/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}