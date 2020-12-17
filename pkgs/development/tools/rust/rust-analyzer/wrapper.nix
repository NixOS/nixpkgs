{ lib, rustPlatform, runCommandNoCC, makeWrapper }:

lib.makeOverridable ({
  unwrapped,
  pname ? "rust-analyzer",
  version ? unwrapped.version,
  # Use name from `RUST_SRC_PATH`
  rustSrc ? rustPlatform.rustLibSrc,
}: runCommandNoCC "${pname}-${version}" {
  inherit pname version;
  inherit (unwrapped) src meta;
  nativeBuildInputs = [ makeWrapper ];
} ''
  mkdir -p $out/bin
  makeWrapper ${unwrapped}/bin/rust-analyzer $out/bin/rust-analyzer \
    --set-default RUST_SRC_PATH "${rustSrc}"
'')
