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
    hash = "sha256-FgzmWw8FZb+DNSf2n6H14Rq07+x1LzG9hX4hFetuqDw=";
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
