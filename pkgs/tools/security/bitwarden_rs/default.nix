{ stdenv, rustPlatform, fetchFromGitHub
, pkgconfig, openssl
, Security, CoreServices
, dbBackend ? "sqlite", libmysqlclient, postgresql }:

let
  featuresFlag = "--features ${dbBackend}";

in rustPlatform.buildRustPackage rec {
  pname = "bitwarden_rs";
  version = "1.16.1";

  src = fetchFromGitHub {
    owner = "dani-garcia";
    repo = pname;
    rev = version;
    sha256 = "18w6fan133ym8n01h2yfv84h1gh1vyib75ksd6c6a554b8ka864s";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = with stdenv.lib; [ openssl ]
    ++ optionals stdenv.isDarwin [ Security CoreServices ]
    ++ optional (dbBackend == "mysql") libmysqlclient
    ++ optional (dbBackend == "postgresql") postgresql;

  RUSTC_BOOTSTRAP = 1;

  cargoSha256 = "11a1a6q53n8gby7j2ghp8d2yi766fp9wklg48ap5i5afngj5lgzp";
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
