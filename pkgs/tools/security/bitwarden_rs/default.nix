{ lib, stdenv, rustPlatform, fetchFromGitHub, nixosTests
, pkg-config, openssl
, Security, CoreServices
, dbBackend ? "sqlite", libmysqlclient, postgresql }:

let
  featuresFlags = [ "--features" dbBackend ];

in rustPlatform.buildRustPackage rec {
  pname = "bitwarden_rs";
  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "dani-garcia";
    repo = pname;
    rev = version;
    sha256 = "1ncy4iwmdzdp8rv1gc5i4s1rp97d94n4l4bh08v6w4zdpx0zn8b9";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = with lib; [ openssl ]
    ++ optionals stdenv.isDarwin [ Security CoreServices ]
    ++ optional (dbBackend == "mysql") libmysqlclient
    ++ optional (dbBackend == "postgresql") postgresql;

  env.RUSTC_BOOTSTRAP = 1;

  cargoSha256 = "139by5y2ma3v52nabzr5man1qy395rchs2dlivkj9xi829kg4mcr";
  cargoBuildFlags = featuresFlags;

  checkPhase = ''
    runHook preCheck
    echo "Running cargo cargo test ${toString featuresFlags} -- "''${checkFlags[@]}" ''${checkFlagsArray+''${checkFlagsArray[@]}}"
    cargo test ${toString featuresFlags} -- "''${checkFlags[@]}" ''${checkFlagsArray+"''${checkFlagsArray[@]}"}
    runHook postCheck
  '';

  passthru.tests = nixosTests.bitwarden;

  meta = with lib; {
    description = "Unofficial Bitwarden compatible server written in Rust";
    homepage = "https://github.com/dani-garcia/bitwarden_rs";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ msteen ];
  };
}
