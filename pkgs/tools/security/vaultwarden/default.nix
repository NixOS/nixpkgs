{ lib, stdenv, rustPlatform, fetchFromGitHub, fetchurl, nixosTests
, pkg-config, openssl
, libiconv, Security, CoreServices
, dbBackend ? "sqlite", libmysqlclient, postgresql }:

let
  featuresFlag = "--features ${dbBackend}";

in rustPlatform.buildRustPackage rec {
  pname = "vaultwarden";
  version = "1.22.1";

  src = fetchFromGitHub {
    owner = "dani-garcia";
    repo = pname;
    rev = version;
    sha256 = "sha256-aXbnNO3mTAgE1yNx7YVDo1vPpO8ACZpBGHQ633fNZ3k=";
  };

  cargoSha256 = "sha256-SFzq3OU0a0s3zlEzUkqGdZb/knYafqDamLy4ghH4i8I=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = with lib; [ openssl ]
    ++ optionals stdenv.isDarwin [ libiconv Security CoreServices ]
    ++ optional (dbBackend == "mysql") libmysqlclient
    ++ optional (dbBackend == "postgresql") postgresql;

  RUSTC_BOOTSTRAP = 1;

  cargoBuildFlags = [ featuresFlag ];

  checkPhase = ''
    runHook preCheck
    echo "Running cargo cargo test ${featuresFlag} -- ''${checkFlags} ''${checkFlagsArray+''${checkFlagsArray[@]}}"
    cargo test ${featuresFlag} -- ''${checkFlags} ''${checkFlagsArray+"''${checkFlagsArray[@]}"}
    runHook postCheck
  '';

  passthru.tests = nixosTests.vaultwarden;

  meta = with lib; {
    description = "Unofficial Bitwarden compatible server written in Rust";
    homepage = "https://github.com/dani-garcia/vaultwarden";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ msteen ];
  };
}
