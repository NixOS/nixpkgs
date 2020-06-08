{ stdenv, rustPlatform, fetchFromGitHub
, pkgconfig, openssl
, Security, CoreServices
, dbBackend ? "sqlite", libmysqlclient, postgresql }:

let
  featuresFlag = "--features ${dbBackend}";

in rustPlatform.buildRustPackage rec {
  pname = "bitwarden_rs";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "dani-garcia";
    repo = pname;
    rev = version;
    sha256 = "12mr7d0mjlh7za4nc3s7cizzbd6v0zfmd7q9s0f7pqz56vw5m21s";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = with stdenv.lib; [ openssl ]
    ++ optionals stdenv.isDarwin [ Security CoreServices ]
    ++ optional (dbBackend == "mysql") libmysqlclient
    ++ optional (dbBackend == "postgresql") postgresql;

  RUSTC_BOOTSTRAP = 1;

  cargoSha256 = "0nacc8xvbkdzbyx4c17hdh03v9ykpis74pbpxkn6v95njw14wq53";
  cargoBuildFlags = [ featuresFlag ];

  checkPhase = ''
    runHook preCheck
    echo "Running cargo cargo test ${featuresFlag} -- ''${checkFlags} ''${checkFlagsArray+''${checkFlagsArray[@]}}"
    cargo test ${featuresFlag} -- ''${checkFlags} ''${checkFlagsArray+"''${checkFlagsArray[@]}"}
    runHook postCheck
  '';

  meta = with stdenv.lib; {
    description = "Unofficial Bitwarden compatible server written in Rust";
    homepage = "https://github.com/dani-garcia/bitwarden_rs";
    license = licenses.gpl3;
    maintainers = with maintainers; [ msteen ];
    platforms = platforms.all;
  };
}
