{
  lib,
  rustPlatform,
  fetchCrate,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "rune-languageserver";
  version = "0.12.4";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-KVNof5s3hiCabsoypwS22FMyJIPF9aU8HNqVKPNo7Fk=";
  };

  cargoHash = "sha256-HiydWqOHz4LJJwJTclRlQfOphE1W03HTMjCtqr1XnJs=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  env = {
    RUNE_VERSION = version;
  };

  meta = with lib; {
    description = "A language server for the Rune Language, an embeddable dynamic programming language for Rust";
    homepage = "https://crates.io/crates/rune-languageserver";
    changelog = "https://github.com/rune-rs/rune/releases/tag/${version}";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "rune-languageserver";
  };
}
