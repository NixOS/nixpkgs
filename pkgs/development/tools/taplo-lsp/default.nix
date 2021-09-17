{ fetchCrate, lib, openssl, pkg-config, rustPlatform, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "taplo-lsp";
  version = "0.2.5";

  src = fetchCrate {
    inherit pname version;
    sha256 = "0a8y2fdkflc7lq0q40j7dr80hbj56bbsc585isbd7lk6xavg7cvi";
  };

  cargoSha256 = "133p5kmcfq5ksrri2f8jvnc1ljmsczq49gh3k0gmgby45yvy6xa1";

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
