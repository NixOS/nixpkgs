{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gevent,
  python,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "yappi";
  version = "1.6.10";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sumerc";
    repo = "yappi";
    tag = version;
    hash = "sha256-RVa8IzyRuIQMfI0DhKdybJBBwqmyc2KI8XjD0PKQ8M8=";
  };

  patches = [ ./tests.patch ];

  build-system = [ setuptools ];

  nativeCheckInputs = [ gevent ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} run_tests.py
    runHook postCheck
  '';

  pythonImportsCheck = [ "yappi" ];

  meta = with lib; {
    description = "Python profiler that supports multithreading and measuring CPU time";
    mainProgram = "yappi";
    homepage = "https://github.com/sumerc/yappi";
    license = licenses.mit;
    maintainers = [ ];
  };
}
