{
  mkKdeDerivation,
  sources,
  pkg-config,
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
    hash = "sha256-66FqoD3JoPbtg6zc32uaPYaTo4zHxywiN8wPI2jtcjc=";
  };

  extraNativeBuildInputs = [
    pkg-config
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
