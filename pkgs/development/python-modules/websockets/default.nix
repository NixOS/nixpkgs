{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, pythonOlder
, stdenv
}:

buildPythonPackage rec {
  pname = "websockets";
  version = "9.1";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aaugustin";
    repo = pname;
    rev = version;
    sha256 = "sha256-7Y12IUG+ulD4+CTRlY+NE6qYZyI9gCPDydwpt+uyYZk=";
  };

  # Tests fail on Darwin with `OSError: AF_UNIX path too long`
  doCheck = !stdenv.isDarwin;

  # Disable all tests that need to terminate within a predetermined amount of
  # time. This is nondeterministic.
  patchPhase = ''
    sed -i 's/with self.assertCompletesWithin.*:/if True:/' \
      tests/legacy/test_protocol.py
  '';

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m unittest discover
    runHook postCheck
  '';

  pythonImportsCheck = [ "websockets" ];

  meta = with lib; {
    description = "WebSocket implementation in Python";
    homepage = "https://websockets.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
