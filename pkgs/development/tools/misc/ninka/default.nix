{ stdenv, fetchurl, perl }:

assert stdenv ? glibc;

stdenv.mkDerivation rec {
  name = "ninka-${version}";
  version = "1.1";

  src = fetchurl {
    url = "https://github.com/dmgerman/ninka/archive/${version}.tar.gz";
    sha256 = "1cvbsmanw3i9igiafpx0ghg658c37riw56mjk5vsgpmnn3flvhib";
  };
  
  buildInputs = [ perl ];
  
  buildPhase = ''
    cd comments
    sed -i -e "s|/usr/local/bin|$out/bin|g" -e "s|/usr/local/man|$out/share/man|g" Makefile
    make
  '';
  
  installPhase = ''
    mkdir -p $out/{bin,share/man/man1}
    make install    

    cp -a ../{ninka.pl,extComments,splitter,filter,senttok,matcher} $out/bin
  '';
  
  meta = {
    description = "A sentence based license detector";
    homepage = "http://ninka.turingmachine.org/";
    license = stdenv.lib.licenses.agpl3Plus;
  };
}
