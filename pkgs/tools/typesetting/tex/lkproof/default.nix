{ lib, stdenv, fetchurl, unzip }:

stdenv.mkDerivation {
  pname = "lkproof";
  version = "3.1";

  src = fetchurl {
    url = "http://mirror.ctan.org/macros/latex/contrib/lkproof.zip";
    sha256 = "1qjkjhpc4rm62qxn18r83zdlwnj1wvnkcpdiqlv7w4bakh0gvjly";
  };

  nativeBuildInputs = [ unzip ];

  installPhase =
    "\n    mkdir -p $out/share/texmf-nix/tex/generic/lkproof\n    cp -prd *.sty $out/share/texmf-nix/tex/generic/lkproof\n  ";

  meta = with lib; {
    platforms = platforms.unix;
    license = licenses.gpl1Plus;
  };
}
