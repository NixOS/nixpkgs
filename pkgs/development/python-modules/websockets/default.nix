{ lib
, fetchFromGitHub
, fetchpatch
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

  patches = [
    (fetchpatch {
      name = "CVE-2021-33880.patch";
      url = "https://github.com/aaugustin/websockets/commit/547a26b685d08cac0aa64e5e65f7867ac0ea9bc0.patch";
      excludes = [ "docs/changelog.rst" ];
      sha256 = "1wgsvza53ga8ldrylb3rqc17yxcrchwsihbq6i6ldpycq83q5akq";
    })
  ];

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
