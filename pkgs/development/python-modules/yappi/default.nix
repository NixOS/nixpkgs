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
<<<<<<< HEAD
  version = "1.7.3";
=======
  version = "1.6.10";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sumerc";
    repo = "yappi";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-YbWPx5Wf1s1UCCiDCInw66VnZ005LfON81MN3phT+fU=";
=======
    hash = "sha256-RVa8IzyRuIQMfI0DhKdybJBBwqmyc2KI8XjD0PKQ8M8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Python profiler that supports multithreading and measuring CPU time";
    mainProgram = "yappi";
    homepage = "https://github.com/sumerc/yappi";
    license = lib.licenses.mit;
    maintainers = [ ];
=======
  meta = with lib; {
    description = "Python profiler that supports multithreading and measuring CPU time";
    mainProgram = "yappi";
    homepage = "https://github.com/sumerc/yappi";
    license = licenses.mit;
    maintainers = with maintainers; [ orivej ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
