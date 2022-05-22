{ lib
, buildPythonPackage
, fetchFromGitHub
, gevent
, python
, pythonOlder
}:

buildPythonPackage rec {
  pname = "yappi";
  version = "1.3.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sumerc";
    repo = pname;
    # https://github.com/sumerc/yappi/issues/102
    rev = "1f41868a2cdfd1e935a5a60808f7bb09c871fa53";
    hash = "sha256-XxUAYrDQAY7fD9yTSmoRUmWJEs+L6KSQ0/bIVf/o9ag=";
  };

  patches = [
    ./tests.patch
  ];

  checkInputs = [
    gevent
  ];

  checkPhase = ''
    ${python.interpreter} run_tests.py
  '';

  pythonImportsCheck = [
    "yappi"
  ];

  meta = with lib; {
    description = "Python profiler that supports multithreading and measuring CPU time";
    homepage = "https://github.com/sumerc/yappi";
    license = licenses.mit;
    maintainers = with maintainers; [ orivej ];
  };
}
