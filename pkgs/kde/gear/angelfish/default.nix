{
  mkKdeDerivation,
  sources,
  qtsvg,
  qtwebengine,
  corrosion,
  rustPlatform,
  cargo,
  rustc,
  # provided as callPackage input to enable easier overrides through overlays
  cargoHash ? "sha256-y7iJGN3ATK3IT8ko64puGlFXBM9OZw9u8JenrOBDuFA=",
  qcoro,
}:
mkKdeDerivation rec {
  pname = "angelfish";
  inherit (sources.${pname}) version;

  cargoDeps = rustPlatform.fetchCargoTarball {
    # include version in the name so we invalidate the FOD
    name = "${pname}-${version}";
    src = sources.${pname};
    hash = cargoHash;
  };

  extraNativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  extraBuildInputs = [qtsvg qtwebengine corrosion qcoro];
}
