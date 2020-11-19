{ lib, buildPythonPackage, fetchFromGitHub, gevent, isPy27, python }:

buildPythonPackage rec {
  pname = "yappi";
  version = "1.3.0";
  disabled = isPy27; # invalid syntax

  src = fetchFromGitHub {
    owner = "sumerc";
    repo = pname;
    rev = "30f94024a0e2e4fa21c220de6a0dc97b4cb2c319";
    sha256 = "1kvwl3y3c2hivf9y2x1q1s8a2y724iwqd1krq6ryvsbg3inyh8qw";
  };

  patches = [ ./tests.patch ];
  checkInputs = [ gevent ];
  checkPhase = ''
    ${python.interpreter} run_tests.py
  '';

  meta = with lib; {
    homepage = "https://github.com/sumerc/yappi";
    description = "Python profiler that supports multithreading and measuring CPU time";
    license = licenses.mit;
    maintainers = with maintainers; [ orivej ];
  };
}
