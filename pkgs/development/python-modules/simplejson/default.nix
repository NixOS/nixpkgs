{ lib
, buildPythonPackage
, fetchPypi
, stdenv
, isPy3k
, pytest
}:

buildPythonPackage rec {
  pname = "simplejson";
  version = "3.16.0";
  doCheck = !stdenv.isDarwin;

  src = fetchPypi {
    inherit pname version;
    sha256 = "b1f329139ba647a9548aa05fb95d046b4a677643070dc2afc05fa2e975d09ca5";
  };

  # Package does not need pytest, but its a bit easier debugging.
  checkInputs = [ pytest ];
  # Ignore warnings because test does not expect them in stderr
  # See https://github.com/simplejson/simplejson/issues/241
  checkPhase = ''
    PYTHONWARNINGS="ignore" pytest simplejson/tests
  '';

  meta = {
    description = "A simple, fast, extensible JSON encoder/decoder for Python";
    longDescription = ''
      simplejson is compatible with Python 2.4 and later with no
      external dependencies.  It covers the full JSON specification
      for both encoding and decoding, with unicode support.  By
      default, encoding is done in an encoding neutral fashion (plain
      ASCII with \uXXXX escapes for unicode characters).
    '';
    homepage = https://github.com/simplejson/simplejson;
    license = with lib.licenses; [ mit afl21 ];
  };
}
