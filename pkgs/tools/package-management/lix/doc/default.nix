{
  lib,
  src,
  rustPlatform,
  version,
  cargoHash ? null,
  cargoLock ? null,
}:
let
  srcPrefix = if lib.versionOlder "2.92" version then "${src.name or src}" else "${src.name or src}/lix-doc";
in
rustPlatform.buildRustPackage {
  pname = "lix-doc";
  sourceRoot = srcPrefix;

  inherit
    version
    src
    cargoHash
    cargoLock
    ;
}
