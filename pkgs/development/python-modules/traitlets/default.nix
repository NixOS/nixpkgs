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
  version = "4.3.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9c4bd2d267b7153df9152698efb1050a5d84982d3384a37b2c1f7723ba3e7835";
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