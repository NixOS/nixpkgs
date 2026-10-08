{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fixtures,
  hatch-vcs,
  hatchling,
  python-subunit,
  python,
  testresources,
  testtools,
}:

buildPythonPackage (finalAttrs: {
  pname = "testrepository";
  version = "0.0.22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "testing-cabal";
    repo = "testrepository";
    tag = finalAttrs.version;
    hash = "sha256-t5cTVMtzYIu4AIQVUVz3odvj+qFeYyUxIroB3yb0bFQ=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    fixtures
    python-subunit
    testtools
  ];

  nativeCheckInputs = [ testresources ];

  checkPhase = ''
    ${python.interpreter} ./testr
  '';

  meta = {
    description = "Database of test results which can be used as part of developer workflow";
    homepage = "https://github.com/testing-cabal/testrepository";
    changelog = "https://github.com/testing-cabal/testrepository/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    mainProgram = "testr";
  };
})
