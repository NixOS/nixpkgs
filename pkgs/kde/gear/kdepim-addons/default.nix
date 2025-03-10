{
  mkKdeDerivation,
  sources,
  rustPlatform,
  cargo,
  rustc,
  discount,
  corrosion,
  alpaka,
}:
mkKdeDerivation rec {
  pname = "kdepim-addons";

  inherit (sources.${pname}) version;

  cargoRoot = "plugins/webengineurlinterceptor/adblock";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version cargoRoot;
    src = sources.${pname};
    hash = "sha256-v1TJ8xu4zXXig+ESYT0ZL6l1gOTbqyVA1P/6T/YnW0k=";
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
