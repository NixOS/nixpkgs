{ lib, stdenv, rustPlatform, fetchFromGitHub, fetchurl, nixosTests
, pkg-config, openssl
, libiconv, Security, CoreServices
, dbBackend ? "sqlite", libmysqlclient, postgresql }:

rustPlatform.buildRustPackage rec {
  pname = "vaultwarden";
  version = "1.24.0";

  src = fetchFromGitHub {
    owner = "dani-garcia";
    repo = pname;
    rev = version;
    sha256 = "sha256-zeMVdsTSp1z8cwebU2N6w7436N8CcI7PzNedDOSvEx4=";
  };

  cargoSha256 = "sha256-Sn6DuzV2OfaywE0W2afRG0h8PfOprqMtZtYM/exGEww=";

  postPatch = ''
    # Upstream specifies 1.57; nixpkgs has 1.56 which also produces a working
    # vaultwarden when using RUSTC_BOOTSTRAP=1
    sed -ri 's/^rust-version = .*//g' Cargo.toml
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = with lib; [ openssl ]
    ++ optionals stdenv.isDarwin [ libiconv Security CoreServices ]
    ++ optional (dbBackend == "mysql") libmysqlclient
    ++ optional (dbBackend == "postgresql") postgresql;

  # vaultwarden depends on rocket v0.5.0-dev, which requires nightly features.
  # This may be removed if https://github.com/dani-garcia/vaultwarden/issues/712 is fixed.
  RUSTC_BOOTSTRAP = 1;

  buildFeatures = dbBackend;

  passthru.tests = nixosTests.vaultwarden;

  meta = with lib; {
    description = "Unofficial Bitwarden compatible server written in Rust";
    homepage = "https://github.com/dani-garcia/vaultwarden";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ msteen ivan ];
  };
}
