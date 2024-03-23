{
  mkKdeDerivation,
  sources,
  corrosion,
  xapian,
  rustPlatform,
  cargo,
  rustc,
  # provided as callPackage input to enable easier overrides through overlays
  cargoHash ? "sha256-Mo94kfA4w280YdazhuVaS/vw7B0y9W/LYaHLLnV/3IE=",
}:
mkKdeDerivation rec {
  pname = "akonadi-search";
  inherit (sources.${pname}) version;

  cargoRoot = "agent/rs/htmlparser";

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

  extraBuildInputs = [corrosion xapian];
}
