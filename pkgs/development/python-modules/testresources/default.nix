{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  fixtures,
  testtools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "testresources";
  version = "2.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "testing-cabal";
    repo = "testresources";
    tag = version;
    hash = "sha256-CLo0b0V1fXQQFHDn/rYAmZy4ifzMEnFv26opmvn6TdQ=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  nativeCheckInputs = [
    fixtures
    testtools
    pytestCheckHook
  ];

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
