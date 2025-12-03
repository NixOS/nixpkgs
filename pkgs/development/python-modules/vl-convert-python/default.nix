{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  protobuf,
  libffi,
  callPackage,
  librusty_v8 ? callPackage ./librusty_v8.nix { },
  nix-update-script,
}:
buildPythonPackage rec {
  pname = "vl-convert-python";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vega";
    repo = "vl-convert";
    tag = "v${version}";
    hash = "sha256-jOqqqr6O/wHFwUHJ/7iE4N/JXXH1MvqQkAQJ47Ww7YI=";
  };

  patches = [ ./libffi-sys-system-feature.patch ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-oPUpX7aMZBSsVujcXkIBNL8pk2JJ0RyBCwoVsuARkkQ=";
  };

  buildAndTestSubdir = "vl-convert-python";

  env.RUSTY_V8_ARCHIVE = librusty_v8;

  build-system = [
    rustPlatform.maturinBuildHook
    rustPlatform.cargoSetupHook
  ];

  nativeBuildInputs = [ protobuf ];

  buildInputs = [ libffi ];

  pythonImportsCheck = [ "vl_convert" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "vl-convert-python@(.*)"
    ];
  };

  meta = {
    description = "Utilities for converting Vega-Lite specs from the command line and Python";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/vega/vl-convert";
    changelog = "https://github.com/vega/vl-convert/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ antonmosich ];
  };
}
