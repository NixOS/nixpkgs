{ lib
, buildPythonPackage
, fetchFromGitHub
, gevent
, isPy27
, python
}:

buildPythonPackage rec {
  pname = "yappi";
  version = "1.3.2";

  disabled = isPy27; # invalid syntax

  src = fetchFromGitHub {
    owner = "sumerc";
    repo = pname;
    rev = "8bf7a650066f104f59c3cae4a189ec15e7d51c8c";
    sha256 = "1q8lr9n0lny2g3mssy3mksbl9m4k1kqn1a4yv1hfqsahxdvpw2dp";
  };

  patches = [ ./tests.patch ];

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
    homepage = "https://github.com/sumerc/yappi";
    description = "Python profiler that supports multithreading and measuring CPU time";
    license = licenses.mit;
    maintainers = with maintainers; [ orivej ];
  };
}
