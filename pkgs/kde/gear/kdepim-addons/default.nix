{
  mkKdeDerivation,
  sources,
  rustPlatform,
  cargo,
  rustc,
  discount,
  corrosion,
  alpaka,
  # provided as callPackage input to enable easier overrides through overlays
  cargoHash ? "sha256-2t4i7lTJxVNjsU5eO6svadZBIerSyXt6BMScpEl119s=",
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

  extraBuildInputs = [
    discount
    corrosion
    alpaka
  ];
}
