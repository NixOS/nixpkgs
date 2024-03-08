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
  cargoHash ? "sha256-z2W2TxyN6Ye+KUaqz5nPAG5zxeABu/UXWuz+XpDpNfc=",
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
