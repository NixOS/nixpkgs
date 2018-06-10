{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "whitenoise";
  version = "4.0b4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ra2bbsihwfhnf1ibahzzabgfjfghxqcrbfx6r5r50mlil5n8bf4";
  };

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Radically simplified static file serving for WSGI applications";
    homepage = http://whitenoise.evans.io/;
    license = licenses.mit;
  };
}
