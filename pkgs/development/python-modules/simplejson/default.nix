{ lib
, buildPythonPackage
, fetchPypi
, stdenv
}:

buildPythonPackage rec {
  pname = "simplejson";
  version = "3.15.0";
  doCheck = !stdenv.isDarwin;

  src = fetchPypi {
    inherit pname version;
    sha256 = "ad332f65d9551ceffc132d0a683f4ffd12e4bc7538681100190d577ced3473fb";
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
