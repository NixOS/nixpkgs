{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # build inputs
  setuptools,
  setuptools-scm,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "widlparser";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "plinss";
    repo = "widlparser";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vnXel2LT8dYjTypJf6TTB8btkdGC0ljeLJuY7WUE55I=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ typing-extensions ];

  pythonImportsCheck = [ "widlparser" ];

  # https://github.com/plinss/widlparser/blob/v1.5.0/.github/workflows/test.yml
  checkPhase = ''
    runHook preCheck

    python test.py > test-actual.txt
    diff -u test-expected.txt test-actual.txt

    runHook postCheck
  '';

  meta = {
    description = "Stand-alone WebIDL Parser in Python";
    homepage = "https://github.com/plinss/widlparser";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
