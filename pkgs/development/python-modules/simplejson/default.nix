{ lib
, buildPythonPackage
, fetchPypi
, stdenv
}:

buildPythonPackage rec {
  pname = "simplejson";
  version = "3.10.0";
  name = "${pname}-${version}";
  doCheck = !stdenv.isDarwin;

  src = fetchPypi {
    inherit pname version;
    sha256 = "953be622e88323c6f43fad61ffd05bebe73b9fd9863a46d68b052d2aa7d71ce2";
  };

  meta = {
    description = "A simple, fast, extensible JSON encoder/decoder for Python";
    longDescription = ''
      simplejson is compatible with Python 2.4 and later with no
      external dependencies.  It covers the full JSON specification
      for both encoding and decoding, with unicode support.  By
      default, encoding is done in an encoding neutral fashion (plain
      ASCII with \uXXXX escapes for unicode characters).
    '';
    homepage = http://code.google.com/p/simplejson/;
    license = lib.licenses.mit;
  };
}
