{ lib
, stdenv
, fetchpatch
, fetchFromGitHub
, rustPlatform
}:
let
  version = "0.2.0";
  author = "mgdm";
  pname = "htmlq";
in
rustPlatform.buildRustPackage rec {
  inherit version pname;

  src = fetchFromGitHub {
    owner = "${author}";
    repo = "${pname}";
    rev = "v${version}";
    hash = "sha256-Q2zjrHKFWowx2yB1cdGxPnNnc8yQJz65HaX0yIqbHks=";
  };

  cargoSha256 = "sha256-pPtKPVSdEtEPmQPpNRJ4uyguDRAW0YvKgdUw5OAtbjA=";

  doCheck = false;

  meta = with lib; {
    description = "Like jq, but for HTML";
    homepage = "https://github.com/${author}/${pname}";
    license = licenses.mit;
    maintainers = with maintainers; [ nerdypepper ];
  };
}
