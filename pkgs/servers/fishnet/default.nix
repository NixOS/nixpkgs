{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, fetchurl
}:

let
  nnueFile = "nn-13406b1dcbe0.nnue";
  nnue = fetchurl {
    url = "https://tests.stockfishchess.org/api/nn/${nnueFile}";
    sha256 = "sha256-E0BrHcvgo238XgfaUdjbOLekXX2kMHjsJadiTCuDI28=";
  };
in
rustPlatform.buildRustPackage rec {
  pname = "fishnet";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "niklasf";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-nVRG60sSpTqfqhCclvWoeyHR0+oO1Jn1PgftigDGq5c=";
    fetchSubmodules = true;
  };

  postPatch = ''
    cp -v '${nnue}' 'Stockfish/src/${nnueFile}'
    cp -v '${nnue}' 'Fairy-Stockfish/src/${nnueFile}'
  '';

  cargoSha256 = "sha256-BJK7M/pjHRj74xoeciavhkK2YRpeogkELIuXetX73so=";

  # TODO: Cargo.lock is out of date, so fix it. Likely not necessary anymore in
  # the next update.
  cargoPatches = [
    ./Cargo.lock.patch
  ];

  meta = with lib; {
    description = "Distributed Stockfish analysis for lichess.org";
    homepage = "https://github.com/niklasf/fishnet";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ tu-maurice ];
    platforms = [ "x86_64-linux" ];
  };
}
