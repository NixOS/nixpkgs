{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "pgf-3.00";
  
  src = fetchurl {
    url = http://downloads.sourceforge.net/project/pgf/pgf/version%203.0.0/pgf_3.0.0.tds.zip;
    sha256 = "0kj769hyp4z2zmdv3f8xv443wcfqn5nkkbzxzqgfxjizlz81aav7";
  };
  
  buildInputs = [ unzip ];

  # Multiple files problem
  unpackPhase = ''
    mkdir pgf
    cd pgf
    unzip $src
  '';

  buildPhase = "true";
  
  installPhase = "
    mkdir -p $out/share/texmf-nix
    cp -prd * $out/share/texmf-nix
  ";
}
