{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "frogatto-data";
  version = "unstable-2021-05-24";

  src = fetchFromGitHub {
    owner = "frogatto";
    repo = "frogatto";
    # master branch as of 2021-11-29
    rev = "82d3dafa0cfeaad016a427bdbc729eb9509748f1";
    sha256 = "0fmwn584xl0vafcsh72b4xnryfqyjxk5zhmymg5i8rzp6h03n8xq";
  };

  installPhase = ''
    mkdir -p $out/share/frogatto/modules
    cp -ar . $out/share/frogatto/modules/frogatto
  '';

  meta = with lib; {
    homepage = "https://github.com/frogatto/frogatto";
    description = "Data files to the frogatto game";
    license = with licenses; [ cc-by-30 unfree ];
    maintainers = with maintainers; [ astro ];
  };
}
