{ lib, rustPlatform, fetchCrate, pkg-config, openssl, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "panamax";
  version = "1.0.3";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-w4waFdzd/Ps0whOp39QLBE/YF2eyc4t2Ili7FskUt1M=";
  };

  cargoSha256 = "sha256-52snmkTFHI26xJo9qJkmqh1M5lLzhDxw8WT6uFd57aw=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Mirror rustup and crates.io repositories for offline Rust and cargo usage";
    homepage = "https://github.com/panamax-rs/panamax";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
