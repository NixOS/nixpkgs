{
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
  lib,
  pytestCheckHook,
  pyyaml,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "ua-parser-rs";
  version = "0.1.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ua-parser";
    repo = "uap-rust";
    tag = "ua-parser-rs-${version}";
    hash = "sha256-Tro3aPjqDN/9c3wBUDDafDpdYXhHEAHeP8NwoU9a4u0=";
    fetchSubmodules = true;
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-NZpMW8cFXXpkSP8jMcXMiDyfyIuhR5C0TUzBsJVkOEE=";
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

  meta = {
    description = "Native accelerator for ua-parser";
    homepage = "https://github.com/ua-parser/uap-rust/tree/main/ua-parser-py";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
