{
  src,
  rustPlatform,
  version,
  cargoHash ? null,
  cargoLock ? null
}:

rustPlatform.buildRustPackage {
  pname = "lix-doc";
  sourceRoot = "${src.name}/lix-doc";
  inherit version src cargoHash cargoLock;
}
