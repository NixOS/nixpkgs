{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, fetchurl
}:

let
  nnueFile = "nn-5af11540bbfe.nnue";
  nnue = fetchurl {
    url = "https://tests.stockfishchess.org/api/nn/${nnueFile}";
    hash = "sha256-WvEVQLv+/LVOOMXdAAyrS0ad+nWZodVb5dJyLCCokps=";
  };
in
rustPlatform.buildRustPackage rec {
  pname = "fishnet";
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "lichess-org";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-q73oGQYSWx1aFy9IvbGpecOoc0wLEY2IzJH9GufnvCs=";
    fetchSubmodules = true;
  };

  postPatch = ''
    cp -v '${nnue}' 'Stockfish/src/${nnueFile}'
    cp -v '${nnue}' 'Fairy-Stockfish/src/${nnueFile}'
  '';

  # Copying again bacause the file is deleted during build.
  postBuild = ''
    cp -v '${nnue}' 'Stockfish/src/${nnueFile}'
  '';

  cargoHash = "sha256-NO3u2ZXSiDQnZ/FFZLOtTnQoGMyN9pSI4sqGIXtjEcI=";

  meta = with lib; {
    description = "Distributed Stockfish analysis for lichess.org";
    homepage = "https://github.com/lichess-org/fishnet";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ tu-maurice ];
    platforms = [ "aarch64-linux" "x86_64-linux" ];
    mainProgram = "fishnet";
  };
}
