{ stdenv, fetchFromGitHub }:
  
stdenv.mkDerivation rec {
  pname = "frogatto-data";
  version = "unstable-2018-12-18";
  
  src = fetchFromGitHub {
    owner = "frogatto";
    repo = "frogatto";
    # master branch as of 2018-12-18
    rev = "8f261b5d3fca3c88e6a534316a28378cf687d3e5";
    sha256 = "0nyfwfyy5gxp61ydna299nq9p5wra9mk0bf1drdngg6bwws1hrqx";
  };

  installPhase = ''
    mkdir -p $out/share/frogatto/modules
    cp -ar . $out/share/frogatto/modules/frogatto
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/frogatto/frogatto;
    description = "Data files to the frogatto game";
    license = with licenses; [ cc-by-30 unfree ];
    maintainers = with maintainers; [ astro ];
  };
}
