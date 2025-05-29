{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pbr,
  fixtures,
  testtools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "testresources";
  version = "2.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "testing-cabal";
    repo = "testresources";
    tag = version;
    hash = "sha256-cdZObOgBOUxYg4IGUUMb6arlpb6NTU7w+EW700LKH4Y=";
  };

  build-system = [
    setuptools
    pbr
  ];

  dependencies = [
    pbr
  ];

  nativeCheckInputs = [
    fixtures
    testtools
    pytestCheckHook
  ];

  env.PBR_VERSION = version;

  meta = {
    description = "Pyunit extension for managing expensive test resources";
    homepage = "https://launchpad.net/testresources";
    license = with lib.licenses; [
      asl20 # or
      bsd3
    ];
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
