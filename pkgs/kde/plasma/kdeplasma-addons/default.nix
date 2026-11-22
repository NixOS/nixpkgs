{
  mkKdeDerivation,
  sources,
  rustPlatform,
  rustc,
  cargo,
  pkg-config,
  corrosion,
  qtwebengine,
  hidapi,
}:
mkKdeDerivation rec {
  pname = "kdeplasma-addons";

  inherit (sources.${pname}) version;

  cargoRoot = "kdeds/kameleon/qmk/kameleon-qmk-helper";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version cargoRoot;
    src = sources.${pname};
    hash = "sha256-WluUQ9bXIJKJ6fUTeeyXSa7Lukm7xlkd0LX8RGoLMiM=";
  };

  extraNativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustc
    cargo
    pkg-config
  ];

  extraBuildInputs = [
    corrosion
    qtwebengine
    hidapi
  ];
}
