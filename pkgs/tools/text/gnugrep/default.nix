{stdenv, fetchurl, pcre}:

stdenv.mkDerivation {
  name = "gnugrep-2.5.3";
  
  src = fetchurl {
    url = http://nixos.org/tarballs/grep-2.5.3-with-info.tar.bz2;
    sha256 = "0rg9dipksqzbg8v1xalib1n3xkkycc5r1l2gb9cxy1cz3cjip5l8";
  };
  
  buildInputs = [pcre];

  preBuild = ''
    makeFlagsArray=(mkdir_p="mkdir -p")
  '';
  
  meta = {
    homepage = http://www.gnu.org/software/grep/;
    description = "GNU implementation of the Unix grep command";
  };
}
