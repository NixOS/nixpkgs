{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  poetry-core,

  # tests
  pytestCheckHook,
  pyyaml,

  # Disable checks by default, as checks require pytest, which eventually
  # depends on hatchling, which depends on tomlkit, leading to infinite
  # recursion.
  doCheck ? false,

  # self-reference for tests, since finalAttrs.finalPackage exposes neither
  # `override` nor `overridePythonAttrs`.
  tomlkit,
}:

buildPythonPackage (finalAttrs: {
  pname = "tomlkit";
  version = "0.15.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-fRqey6MIZjghGxOBTqeckN1U3RGZNWQ3bzqpInH1x6M=";
  };

  build-system = [ poetry-core ];

  inherit doCheck;

  nativeCheckInputs = [
    pyyaml
    pytestCheckHook
  ];

  pythonImportsCheck = [ "tomlkit" ];

  # In passthru.tests, build with the check phase enabled, since that'll be
  # outside the bootstrap dependency chain.
  passthru.tests.withChecks = tomlkit.override { doCheck = true; };

  meta = {
    homepage = "https://github.com/sdispater/tomlkit";
    changelog = "https://github.com/sdispater/tomlkit/blob/${finalAttrs.version}/CHANGELOG.md";
    description = "Style-preserving TOML library for Python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jakewaksbaum ];
  };
})
