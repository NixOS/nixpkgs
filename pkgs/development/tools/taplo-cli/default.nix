{ lib, rustPlatform, fetchCrate, stdenv, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "taplo-cli";
  version = "0.6.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-Vki2sjz69tTWGw0y/hivFJ1kyGqRY/lUaUBEliMNvlI=";
  };

  cargoSha256 = "sha256-XqQxWngLioxzhX8ZFAYP5CrL4oI30LxfdWyfAded0bo=";

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
