{
  mkKdeDerivation,
  sources,
  corrosion,
  xapian,
  rustPlatform,
  cargo,
  rustc,
  # provided as callPackage input to enable easier overrides through overlays
  cargoHash ? "sha256-ePvYL1ps2w7qscYNIgvjn6t/ir0izbS+MlP/jow4VrE=",
}:
mkKdeDerivation rec {
  pname = "akonadi-search";
  inherit (sources.${pname}) version;

  cargoRoot = "agent/rs/htmlparser";

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit pname version cargoRoot;
    src = sources.${pname};
    hash = cargoHash;
  };

  extraNativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  extraBuildInputs = [
    corrosion
    xapian
  ];
}
