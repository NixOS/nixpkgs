{ lib, stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "pgf";
  version = "3.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/project/pgf/pgf/version%20${version}/pgf_${version}.tds.zip";
    sha256 = "0kj769hyp4z2zmdv3f8xv443wcfqn5nkkbzxzqgfxjizlz81aav7";
  };

  nativeBuildInputs = [ unzip ];

  # Multiple files problem
  unpackPhase = ''
    mkdir pgf
    cd pgf
    unzip $src
  '';

  dontBuild = true;

  installPhase = "
    mkdir -p $out/share/texmf-nix
    cp -prd * $out/share/texmf-nix
  ";

  meta = with lib; {
    branch = "3";
    platforms = platforms.unix;
    license = licenses.gpl2;
  };
}
