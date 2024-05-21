{
  src,
  rustPlatform,
  version,
  cargoHash,
}:

rustPlatform.buildRustPackage {
  pname = "lix-doc";
  sourceRoot = "${src.name}/lix-doc";
  inherit version src cargoHash;
}
