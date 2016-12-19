{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "lkproof-3.1";
  
  src = fetchurl {
    url = http://mirror.ctan.org/macros/latex/contrib/lkproof.zip;
    sha256 = "1qjkjhpc4rm62qxn18r83zdlwnj1wvnkcpdiqlv7w4bakh0gvjly";
  };
  
  buildInputs = [ unzip ];

  installPhase = "
    mkdir -p $out/share/texmf-nix/tex/generic/lkproof
    cp -prd *.sty $out/share/texmf-nix/tex/generic/lkproof
  ";

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
