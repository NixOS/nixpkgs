{
  mkKdeDerivation,
  sources,
  corrosion,
  xapian,
  rustPlatform,
  cargo,
  rustc,
}:
mkKdeDerivation rec {
  pname = "akonadi-search";
  inherit (sources.${pname}) version;

  cargoRoot = "agent/rs/htmlparser";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version cargoRoot;
    src = sources.${pname};
    hash = "sha256-fx8q7b0KGEevn0DlMAGgAvQMXqZmBF8aINDwpaGyq7I=";
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
