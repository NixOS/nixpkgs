{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, cryptography
, mock
, python
}:

buildPythonPackage rec {
  pname = "stem";
  version = "1.8.3-unstable-2024-02-13";

  disabled = pythonOlder "3.6";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "torproject";
    repo = "stem";
    rev = "9a9c7d43a7fdcde6d4a9cf95b831fb5e5923a160";
    hash = "sha256-Oc73Jx31SLzuhT9Iym5HHszKfflKZ+3aky5flXudvmI=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    cryptography
    mock
  ];

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} run_tests.py --unit

    runHook postCheck
  '';

  meta = with lib; {
    changelog = "https://github.com/torproject/stem/blob/${src.rev}/docs/change_log.rst";
    description = "Controller library that allows applications to interact with Tor";
    mainProgram = "tor-prompt";
    downloadPage = "https://github.com/torproject/stem";
    homepage = "https://stem.torproject.org/";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ dotlambda ];
  };
}
