{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  future,
  python,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "word2number";
  version = "1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "akshaynagpal";
    repo = "w2n";
    tag = version;
    hash = "sha256-dgHPEfieNDZnP6+YvywvN3ZzmeICav0WMYKkWDSJ/LE=";
  };

  build-system = [
    setuptools-scm
  ];

  dependencies = lib.optionals (pythonOlder "3.13") [
    future
  ];

  pythonImportsCheck = [
    "word2number"
  ];

  checkPhase = ''
    ${lib.getExe python} unit_testing.py
  '';

  meta = {
    changelog = "https://github.com/akshaynagpal/w2n/releases/tag/${version}";
    description = "Convert number words (eg. twenty one) to numeric digits (21)";
    homepage = "http://w2n.readthedocs.io/";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.booxter ];
  };
}
