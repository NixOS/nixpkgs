{ fetchCrate, lib, openssl, pkg-config, rustPlatform, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "taplo-cli";
  version = "0.4.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "0hh9l83z7qymakyf7ka756gwxpzirgdhf6kpzh89bcmpdfz70005";
  };

  cargoSha256 = "0bkpcnbrrfv07czs1gy8r9q1cp6fdfz2vmlfk9lsg3iapvyi5s1c";

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
