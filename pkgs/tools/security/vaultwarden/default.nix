{ lib, stdenv, callPackage, rustPlatform, fetchFromGitHub, fetchurl, nixosTests
, pkg-config, openssl
, libiconv, Security, CoreServices
, dbBackend ? "sqlite", libmysqlclient, postgresql }:

let
  webvault = callPackage ./webvault.nix {};
in

rustPlatform.buildRustPackage rec {
  pname = "vaultwarden";
  version = "1.27.0";

  src = fetchFromGitHub {
    owner = "dani-garcia";
    repo = pname;
    rev = version;
    sha256 = "sha256-QvU1Y3syr6PZbTRebbZF4sEzI4lIj1enJe2F/gGfvQM=";
  };

  cargoSha256 = "sha256-lylRGg5pzJ4sBS3bY4ObMoJ5s5kakMLTtq1VOnmS5HM=";

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

  passthru = {
    inherit webvault;
    tests = nixosTests.vaultwarden;
    updateScript = callPackage ./update.nix {};
  };

  meta = with lib; {
    description = "Unofficial Bitwarden compatible server written in Rust";
    homepage = "https://github.com/dani-garcia/vaultwarden";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ msteen ivan ];
  };
}
