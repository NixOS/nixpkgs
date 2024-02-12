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
  version = "1.8.3-unstable-2024-02-11";

  disabled = pythonOlder "3.6";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "torproject";
    repo = "stem";
    rev = "9f1fa4ac53cf83a4cdd7155cc487212bf8bc08af";
    hash = "sha256-AMyF4ir9Utb91dp1Swheyw1zQH6ZvgyW9kFp1g9JoQQ=";
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
    downloadPage = "https://github.com/torproject/stem";
    homepage = "https://stem.torproject.org/";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ dotlambda ];
  };
}
