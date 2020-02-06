{ stdenv, rustPlatform, fetchFromGitHub
, pkgconfig, openssl
, Security, CoreServices
, dbBackend ? "sqlite", libmysqlclient, postgresql }:

let
  featuresFlag = "--features ${dbBackend}";

in rustPlatform.buildRustPackage rec {
  pname = "bitwarden_rs";
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "dani-garcia";
    repo = pname;
    rev = version;
    sha256 = "0af8cnpx86a096m59wmszcfyrfgf7adlqr39phbg647mgjfzwcrk";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = with stdenv.lib; [ openssl ]
    ++ optionals stdenv.isDarwin [ Security CoreServices ]
    ++ optional (dbBackend == "mysql") libmysqlclient
    ++ optional (dbBackend == "postgresql") postgresql;

  RUSTC_BOOTSTRAP = 1;

  cargoSha256 = "1v6n4aqhd5pyvvhlzhpmq7ykclfxw82wn2bg7n49b53d9p72jwq6";
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
