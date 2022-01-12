{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, fetchurl
}:

let
  nnueFile = "nn-6762d36ad265.nnue";
  nnue = fetchurl {
    url = "https://tests.stockfishchess.org/api/nn/${nnueFile}";
    sha256 = "0727dsxfpns9fkyir95fybibqmigk5h45k154b2c5rk5s9md6qk7";
  };
in
rustPlatform.buildRustPackage rec {
  pname = "fishnet";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "niklasf";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1Gl2vJFn9yVYH62yBJefAOBX/jJaFAdSZj2Lj3imcps=";
    fetchSubmodules = true;
  };

  postPatch = ''
    cp -v '${nnue}' 'Stockfish/src/${nnueFile}'
    cp -v '${nnue}' 'Fairy-Stockfish/src/${nnueFile}'
  '';

  cargoSha256 = "sha256-/s7Yyi2FUh+EDvgaHLgZ/FA6kk2FQrZr3L3B76fqTuc=";

  meta = with lib; {
    description = "Distributed Stockfish analysis for lichess.org";
    homepage = "https://github.com/niklasf/fishnet";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ tu-maurice ];
    platforms = [ "x86_64-linux" ];
  };
}
