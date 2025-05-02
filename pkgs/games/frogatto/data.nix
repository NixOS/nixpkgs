{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "frogatto-data";
  version = "unstable-2023-02-27";

  src = fetchFromGitHub {
    owner = "frogatto";
    repo = "frogatto";
    rev = "5ca339f4b97e5004dc07394407bf1da43fbd6204";
    sha256 = "sha256-6wqCFc7DlDt0u0JnPg4amVemc9HOjsB/U4s9n7N84QA=";
  };

  installPhase = ''
    mkdir -p $out/share/frogatto/modules
    cp -ar . $out/share/frogatto/modules/frogatto4
  '';

  meta = with lib; {
    homepage = "https://github.com/frogatto/frogatto";
    description = "Data files to the frogatto game";
    license = with licenses; [ cc-by-30 unfree ];
    maintainers = with maintainers; [ astro ];
  };
}
