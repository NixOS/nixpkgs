{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "frogatto-data";
  version = "unstable-2022-04-13";

  src = fetchFromGitHub {
    owner = "frogatto";
    repo = "frogatto";
    rev = "655493961c4ad57ba9cccdc24d23a2ded294b5f2";
    sha256 = "0irn7p61cs8nm7dxsx84b2c3wryf2h12k2kclywdhy6xmh53w8k1";
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
