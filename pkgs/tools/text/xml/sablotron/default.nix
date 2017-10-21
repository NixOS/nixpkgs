{stdenv, fetchurl, expat} :

stdenv.mkDerivation {
  name = "sablotron-1.0.3";
  src = fetchurl {
    url = "mirror://sourceforge/project/sablotron/sablotron-1.0.3/Sablot-1.0.3.tar.gz";
    sha256 = "0qpk3dlfp3bn2hbq0fzx1bzifv8cgqb9aicn59d303cdlynkgix0";
  };
  buildInputs = [expat];

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
