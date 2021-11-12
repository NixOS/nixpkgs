{ fetchCrate, lib, openssl, pkg-config, rustPlatform, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "taplo-cli";
  version = "0.4.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-bGQLAANVahpiiiKKJPNmtr4uT5iKHqyLS5yVm+rSHPg=";
  };

  cargoSha256 = "sha256-T3fbG5HKOG90kawjQK8D0PIonB6ErNfR3hVIZ5N8zgA=";

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
