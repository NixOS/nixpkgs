{ lib
, buildPythonPackage
, fetchFromGitHub
, stdenv
, pytest
}:

buildPythonPackage rec {
  pname = "simplejson";
  version = "3.17.0";
  doCheck = !stdenv.isDarwin;

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1b1hhh1dia673vhq3jl2br1iqwb9yjii6iak56w96s9972vjbz3z";
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
