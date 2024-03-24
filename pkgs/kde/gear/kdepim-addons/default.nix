{
  mkKdeDerivation,
  sources,
  rustPlatform,
  cargo,
  rustc,
  corrosion,
  discount,
  alpaka,
  # provided as callPackage input to enable easier overrides through overlays
  cargoHash ? "sha256-MMCDfCtGDJ+yrfdpZEMxlSh7yWU6de/Pggw7Op7VxQI=",
}:
mkKdeDerivation rec {
  pname = "kdepim-addons";

  inherit (sources.${pname}) version;

  cargoRoot = "plugins/webengineurlinterceptor/adblock";

  cargoDeps = rustPlatform.fetchCargoTarball {
    # include version in the name so we invalidate the FOD
    name = "${pname}-${version}";
    src = sources.${pname};
    sourceRoot = "${pname}-${version}/${cargoRoot}";
    hash = cargoHash;
  };

  extraNativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  extraBuildInputs = [corrosion discount alpaka];
}
