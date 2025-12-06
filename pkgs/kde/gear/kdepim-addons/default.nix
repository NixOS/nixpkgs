{
  fetchpatch,
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

  patches = [
    (fetchpatch {
      url = "https://invent.kde.org/pim/kdepim-addons/-/commit/9daab0a6a19cca4285c442cc88aab540b6e49d2b.diff";
      revert = true;
      hash = "sha256-tUw9qvanRzqld7uQBCWA8pLcwVxtJ9XIZe62u9bKbAk=";
    })
  ];

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
