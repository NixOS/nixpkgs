{ stdenv, rustPlatform, fetchFromGitHub, nixosTests
, pkgconfig, openssl
, Security, CoreServices
, dbBackend ? "sqlite", libmysqlclient, postgresql }:

let
  featuresFlag = "--features ${dbBackend}";

in rustPlatform.buildRustPackage rec {
  pname = "bitwarden_rs";
  version = "1.16.3";

  src = fetchFromGitHub {
    owner = "dani-garcia";
    repo = pname;
    rev = version;
    sha256 = "1scy8abzy6j1jsms84cg2nqkn1zsxr5mjikp2xh0yl0ckkk13ffn";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = with stdenv.lib; [ openssl ]
    ++ optionals stdenv.isDarwin [ Security CoreServices ]
    ++ optional (dbBackend == "mysql") libmysqlclient
    ++ optional (dbBackend == "postgresql") postgresql;

  RUSTC_BOOTSTRAP = 1;

  cargoSha256 = "112mvgq581cms0war5dbni7f7yryjr5agryzn5qx835qkznzar8s";
  cargoBuildFlags = [ featuresFlag ];

  checkPhase = ''
    runHook preCheck
    echo "Running cargo cargo test ${featuresFlag} -- ''${checkFlags} ''${checkFlagsArray+''${checkFlagsArray[@]}}"
    cargo test ${featuresFlag} -- ''${checkFlags} ''${checkFlagsArray+"''${checkFlagsArray[@]}"}
    runHook postCheck
  '';

  passthru.tests = nixosTests.bitwarden;

  meta = with stdenv.lib; {
    description = "Unofficial Bitwarden compatible server written in Rust";
    homepage = "https://github.com/dani-garcia/bitwarden_rs";
    license = licenses.gpl3;
    maintainers = with maintainers; [ msteen ];
  };
}
