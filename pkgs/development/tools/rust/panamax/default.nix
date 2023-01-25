{ lib
, rustPlatform
, fetchCrate
, pkg-config
, libgit2
, openssl
, zlib
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "panamax";
  version = "1.0.6";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-/JW2QB5PtwKo0TLU/QmkgsE6/ne+51EVmWyGn7Lljdw=";
  };

  cargoSha256 = "sha256-aKdDismdPcExqznS6S2LvAij6gv9/Hw2FBvkhr9rJGo=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "Mirror rustup and crates.io repositories for offline Rust and cargo usage";
    homepage = "https://github.com/panamax-rs/panamax";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
