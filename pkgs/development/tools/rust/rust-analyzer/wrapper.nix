{
  lib,
  rustPlatform,
  runCommand,
  makeWrapper,
  rust-analyzer-unwrapped,
  pname ? "rust-analyzer",
  version ? rust-analyzer-unwrapped.version,
  # Use name from `RUST_SRC_PATH`
  rustSrc ? rustPlatform.rustLibSrc,
}:
runCommand "${pname}-${version}"
  {
    inherit pname version;
    inherit (rust-analyzer-unwrapped) src meta;
    nativeBuildInputs = [ makeWrapper ];
  }
  ''
    mkdir -p $out/bin
    makeWrapper ${rust-analyzer-unwrapped}/bin/rust-analyzer $out/bin/rust-analyzer \
      --set-default RUST_SRC_PATH "${rustSrc}"
  ''
