{
  mkKdeDerivation,
  sources,
  qtsvg,
  qtwebengine,
  corrosion,
  rustPlatform,
  cargo,
  rustc,
  qcoro,
}:
mkKdeDerivation rec {
  pname = "angelfish";
  inherit (sources.${pname}) version;

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version;
    src = sources.${pname};
    hash = "sha256-aGpmkuw7Y0PRFp0+0ozv5/A80O2T9lMN9SJfKfExx/o=";
  };

  extraNativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  extraBuildInputs = [
    qtsvg
    qtwebengine
    corrosion
    qcoro
  ];
}
