{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, mock
, pytest
, selectors2
}:

buildPythonPackage rec {
  pname = "wurlitzer";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0144228960a992ef46e339e8aa560600bd34cd64e018bfebad88c0dd61bd8ba5";
  };

  propagatedBuildInputs = lib.optionals isPy27 [ selectors2 ];

  checkInputs = [ mock pytest ];

  checkPhase = ''
    py.test test.py
  '';

  meta = {
    description = "Capture C-level output in context managers";
    homepage = "https://github.com/minrk/wurlitzer";
    license = lib.licenses.mit;
  };
}
