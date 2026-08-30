{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  pbr,

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
  ];

  propagatedBuildInputs = [
    pbr
    testtools
  ];

  doCheck = false; # tests not compatible with teststools 2.8

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} -m testtools.run testscenarios.tests.test_suite

    runHook postCheck
  '';

  meta = {
    description = "Pyunit extension for dependency injection";
    homepage = "https://github.com/testing-cabal/testscenarios";
    license = lib.licenses.asl20;
  };
}
