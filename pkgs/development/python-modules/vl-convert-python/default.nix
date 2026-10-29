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
buildPythonPackage (finalAttrs: {
  pname = "vl-convert-python";
  version = "1.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vega";
    repo = "vl-convert";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W23cau2VzpvfO6DRa/40UVv4j8AbsNLfAfDaMkTyj6w=";
  };

  patches = [ ./libffi-sys-system-feature.patch ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-P228JMS5K0TbZYyPgKhIbZ1NviwO1jHO5dClFYerNbI=";
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
    changelog = "https://github.com/vega/vl-convert/releases/tag/v${finalAttrs.version}";
    maintainers = [ ];
  };
})
