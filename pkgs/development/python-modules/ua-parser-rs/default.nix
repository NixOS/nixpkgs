{
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
  lib,
  pytestCheckHook,
  pyyaml,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "ua-parser-rs";
  version = "0.1.4";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ua-parser";
    repo = "uap-rust";
    tag = "ua-parser-rs-${finalAttrs.version}";
    hash = "sha256-8IU4NNW0v2zl6COtL6o7FALxqYNVKBGhERugxpXIN5g=";
    fetchSubmodules = true;
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-PNkyd9/0DdIqEmXbnw3dZs5ajWSo0rLhjJwRu3H06Cc=";
  };

  buildAndTestSubdir = "ua-parser-py";

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "ua-parser-rs-"; };

  pythonImportsCheck = [ "ua_parser_rs" ];

  meta = {
    description = "Native accelerator for ua-parser";
    homepage = "https://github.com/ua-parser/uap-rust";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
