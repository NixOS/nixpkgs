{ lib
, buildPythonPackage
, fetchPypi
, stdenv
}:

buildPythonPackage rec {
  pname = "simplejson";
  version = "3.13.2";
  name = "${pname}-${version}";
  doCheck = !stdenv.isDarwin;

  src = fetchPypi {
    inherit pname version;
    sha256 = "4c4ecf20e054716cc1e5a81cadc44d3f4027108d8dd0861d8b1e3bd7a32d4f0a";
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
