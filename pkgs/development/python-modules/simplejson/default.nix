{ lib
, buildPythonPackage
, fetchPypi
, stdenv
}:

buildPythonPackage rec {
  pname = "simplejson";
  version = "3.11.1";
  name = "${pname}-${version}";
  doCheck = !stdenv.isDarwin;

  src = fetchPypi {
    inherit pname version;
    sha256 = "01a22d49ddd9a168b136f26cac87d9a335660ce07aa5c630b8e3607d6f4325e7";
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
