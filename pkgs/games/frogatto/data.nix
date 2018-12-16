{ stdenv, fetchFromGitHub,
}:

let
  version = "0.0.2018-12-09";
  source = fetchFromGitHub {
    owner = "frogatto";
    repo = "frogatto";
    # master branch as of 2018-12-18
    rev = "8f261b5d3fca3c88e6a534316a28378cf687d3e5";
    sha256 = "0nyfwfyy5gxp61ydna299nq9p5wra9mk0bf1drdngg6bwws1hrqx";
  };
in stdenv.mkDerivation {
  name = "frogatto-data-${version}";
  src = source;

  installPhase = ''
    mkdir -p $out/share/frogatto/modules
    cp -ar . $out/share/frogatto/modules/frogatto
  '';
}
