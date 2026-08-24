{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  testtools,

  # tests
  python,
}:

buildPythonPackage (finalAttrs: {
  pname = "testscenarios";
  version = "0.6.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-q1rozVUOEeqXgVGYHnqOysMpt7IuTexwax5v4hP0Y+c=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [ testtools ];

  doCheck = false; # tests not compatible with teststools 2.8

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} -m testtools.run testscenarios.tests.test_suite

    runHook postCheck
  '';

  meta = {
    description = "Pyunit extension for dependency injection";
    homepage = "https://github.com/testing-cabal/testscenarios";
    changelog = "https://github.com/testing-cabal/testscenarios/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [  ];
  };
})
