{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  # build inputs
  setuptools,
  setuptools-scm,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "widlparser";
  version = "1.1.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "plinss";
    repo = "widlparser";
    rev = "v${version}";
    hash = "sha256-G5N29K0/ByfKwP1XfxZH9u/5x361JD/8qAD6eZaySnU=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ typing-extensions ];

  pythonImportsCheck = [ "widlparser" ];

  # https://github.com/plinss/widlparser/blob/v1.1.5/.github/workflows/test.yml
  checkPhase = ''
    runHook preCheck

    python test.py > test-actual.txt
    diff -u test-expected.txt test-actual.txt

    runHook postCheck
  '';

  meta = with lib; {
    description = "Stand-alone WebIDL Parser in Python";
    homepage = "https://github.com/plinss/widlparser";
    license = licenses.mit;
    maintainers = [ ];
  };
}
