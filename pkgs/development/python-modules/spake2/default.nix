{ lib, buildPythonPackage, fetchPypi, hkdf, pytest }:

buildPythonPackage rec {
  pname = "spake2";
  version = "0.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c17a614b29ee4126206e22181f70a406c618d3c6c62ca6d6779bce95e9c926f4";
  };

  checkInputs = [ pytest ];

  propagatedBuildInputs = [ hkdf ];

  checkPhase = ''
    py.test $out
  '';

  meta = with lib; {
    description = "SPAKE2 password-authenticated key exchange library";
    homepage = "http://github.com/warner/python-spake2";
    license = licenses.mit;
  };
}
