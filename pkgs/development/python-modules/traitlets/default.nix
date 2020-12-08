{ lib
, buildPythonPackage
, isPy27
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
  version = "5.0.5";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "178f4ce988f69189f7e523337a3e11d91c786ded9360174a3d9ca83e79bc5396";
  };

  checkInputs = [ glibcLocales pytest mock ];
  propagatedBuildInputs = [ ipython_genutils decorator six ] ++ lib.optional (pythonOlder "3.4") enum34;

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
