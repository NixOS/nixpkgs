{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gevent,
  python,
  setuptools,
}:

buildPythonPackage rec {
  pname = "yappi";
  version = "1.7.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sumerc";
    repo = "yappi";
    tag = version;
    hash = "sha256-YbWPx5Wf1s1UCCiDCInw66VnZ005LfON81MN3phT+fU=";
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

  meta = {
    description = "Python profiler that supports multithreading and measuring CPU time";
    mainProgram = "yappi";
    homepage = "https://github.com/sumerc/yappi";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
