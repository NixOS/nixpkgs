{ lib
, buildPythonPackage
, fetchFromGitHub
, gevent
, python
, pythonOlder
}:

buildPythonPackage rec {
  pname = "yappi";
  version = "1.3.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sumerc";
    repo = pname;
    rev = version;
    hash = "sha256-MfvaLWw7EhfzFx4aZdRWvQVOOcvZ1Mt7EgxyB2nDB2c=";
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
