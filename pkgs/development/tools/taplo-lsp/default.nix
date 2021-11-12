{ fetchCrate, lib, openssl, pkg-config, rustPlatform, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "taplo-lsp";
  version = "0.2.6";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-jd4l9iTCeHnUa/GC13paD3zDiCZBk9VgEbCDsOs/Xq4=";
  };

  cargoSha256 = "sha256-zQ303JFqnbulkWL4t5+fRWijaY9zd9tLKvrvdUEvKpY=";

  # excludes test_tcp since it fails
  cargoTestFlags = [ "test_stdio" ];

  nativeBuildInputs = lib.optional stdenv.isLinux pkg-config;

  buildInputs = lib.optional stdenv.isLinux openssl
    ++ lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "A TOML toolkit written in Rust";
    homepage = "https://taplo.tamasfe.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
