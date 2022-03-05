{ lib, rustPlatform, fetchCrate, stdenv, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "taplo-cli";
  version = "0.5.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-+0smR1FDeJMSa/LaRM2M53updt5p8717DEaFItNXCdM=";
  };

  cargoSha256 = "sha256-d7mysGYR72shXwvmDXr0oftSa+RtRoSbP++HBR40Mus=";

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
