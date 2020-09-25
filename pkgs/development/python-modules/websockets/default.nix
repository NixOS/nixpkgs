{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, pytest
, stdenv
}:

buildPythonPackage rec {
  pname = "websockets";
  version = "8.1";

  src = fetchFromGitHub {
    owner = "aaugustin";
    repo = pname;
    rev = version;
    sha256 = "05jbqcbjg50ydwl0fijhdlqcq7fl6v99kjva66kmmzzza7vwa872";
  };

  disabled = pythonOlder "3.3";

  # Tests fail on Darwin with `OSError: AF_UNIX path too long`
  doCheck = !stdenv.isDarwin;

  # Disable all tests that need to terminate within a predetermined amount of
  # time.  This is nondeterministic.
  patchPhase = ''
    sed -i 's/with self.assertCompletesWithin.*:/if True:/' \
      tests/test_protocol.py
  '';

  meta = with lib; {
    description = "WebSocket implementation in Python 3";
    homepage = "https://github.com/aaugustin/websockets";
    license = licenses.bsd3;
  };
}
