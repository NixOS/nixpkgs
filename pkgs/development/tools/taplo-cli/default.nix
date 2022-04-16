{ lib, rustPlatform, fetchCrate, stdenv, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "taplo-cli";
  version = "0.6.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-0U7qoRnId3gKTQYPwbvrt/vzGfiSX6kcGwgRNc1uZ/I=";
  };

  cargoSha256 = "sha256-FIcq8wwJrZRxATDr+jo4KOX4l6auriNg+rSpMNsG+Tk=";

  nativeBuildInputs = lib.optional stdenv.isLinux pkg-config;

  buildInputs = lib.optional stdenv.isLinux openssl
    ++ lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "A TOML toolkit written in Rust";
    homepage = "https://taplo.tamasfe.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "taplo";
  };
}
