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
  version = "1.8.2";

  disabled = pythonOlder "3.6";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "torproject";
    repo = "stem";
    rev = "refs/tags/${version}";
    hash = "sha256-9BXeE/sVa13jr8G060aWjc49zgDVBhjaR6nt4lSxc0g=";
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
