{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fixtures,
  hatch-vcs,
  hatchling,
  pbr,
  pytestCheckHook,
  testtools,
}:

buildPythonPackage (finalAttrs: {
  pname = "testresources";
  version = "2.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "testing-cabal";
    repo = "testresources";
    tag = finalAttrs.version;
    hash = "sha256-CLo0b0V1fXQQFHDn/rYAmZy4ifzMEnFv26opmvn6TdQ=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [ pbr ];

  nativeCheckInputs = [
    fixtures
    testtools
    pytestCheckHook
  ];

  env.PBR_VERSION = finalAttrs.version;

  meta = {
    description = "Pyunit extension for managing expensive test resources";
    homepage = "https://launchpad.net/testresources";
    license = with lib.licenses; [
      asl20 # or
      bsd3
    ];
    maintainers = with lib.maintainers; [ nickcao ];
  };
})
