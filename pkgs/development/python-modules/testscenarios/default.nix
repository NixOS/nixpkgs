{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  pbr,
  setuptools,

  # dependencies
  testtools,

  # tests
  python,
}:

buildPythonPackage rec {
  pname = "testscenarios";
  version = "0.5.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wlfLa5Dqfm+P7zFYEh1DBUNBLJqH3zC13ebsi5tXorY=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "buffer = 1" "" \
      --replace "catch = 1" ""
  '';

  nativeBuildInputs = [
    pbr
    setuptools
  ];

  propagatedBuildInputs = [
    pbr
    testtools
  ];

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} -m testtools.run testscenarios.tests.test_suite

    runHook postCheck
  '';

  meta = with lib; {
    description = "Pyunit extension for dependency injection";
    homepage = "https://github.com/testing-cabal/testscenarios";
    license = licenses.asl20;
  };
}
