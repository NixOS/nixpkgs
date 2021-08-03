{ fetchCrate, lib, openssl, pkg-config, rustPlatform, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "taplo-lsp";
  version = "0.2.4";

  src = fetchCrate {
    inherit pname version;
    sha256 = "1a5v0x60iicv9snsr0a3lqbziyh38iqhiw11s2lqnr6l1hmp69jy";
  };

  cargoSha256 = "0ak70cwxcviv86b4zrcgqaxhdm6fxsji03mnacvp4pwlwv84ikkc";

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
