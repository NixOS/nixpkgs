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
    hash = "sha256-XbFbS8zNcrj8T2Av67f9JFAgheso9WW6flr3FabhL4I=";
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
