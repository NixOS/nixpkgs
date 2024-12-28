{
  src,
  rustPlatform,
  version,
  cargoHash ? null,
  cargoLock ? null,
}:

rustPlatform.buildRustPackage {
  pname = "lix-doc";
  sourceRoot = "${src.name or src}/lix-doc";
  inherit
    version
    src
    cargoHash
    cargoLock
    ;
}
