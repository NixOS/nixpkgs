{ lib, stdenv, rustPlatform, fetchFromGitHub, nixosTests
, pkg-config, openssl
, Security, CoreServices
, dbBackend ? "sqlite", libmysqlclient, postgresql }:

let
  featuresFlag = "--features ${dbBackend}";

in rustPlatform.buildRustPackage rec {
  pname = "bitwarden_rs";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "dani-garcia";
    repo = pname;
    rev = version;
    sha256 = "1iww8fhh4indmgw1j35whqyakd4bppmiyjpcdf2qrzg52x5binh0";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = with lib; [ openssl ]
    ++ optionals stdenv.isDarwin [ Security CoreServices ]
    ++ optional (dbBackend == "mysql") libmysqlclient
    ++ optional (dbBackend == "postgresql") postgresql;

  RUSTC_BOOTSTRAP = 1;

  cargoSha256 = "0kc407i9s47l9ay21xi89sskdj0maq5sv4i87lal6xh896qqyn3v";
  cargoBuildFlags = [ featuresFlag ];

  checkPhase = ''
    runHook preCheck
    echo "Running cargo cargo test ${featuresFlag} -- ''${checkFlags} ''${checkFlagsArray+''${checkFlagsArray[@]}}"
    cargo test ${featuresFlag} -- ''${checkFlags} ''${checkFlagsArray+"''${checkFlagsArray[@]}"}
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
