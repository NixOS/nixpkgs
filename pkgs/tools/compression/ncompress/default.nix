{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "ncompress-4.2.4";
  
  builder = ./builder.sh;

  patches = [ ./makefile.patch ];
    
  src = fetchurl {
    url = mirror://sourceforge/project/ncompress/ncompress%20%28bugfixes%29/ncompress-4.2.4.2/ncompress-4.2.4.2.tar.gz;
    sha256 = "38158c792b769fe23c74f8d3ea0e27569a9b1d21b53a4faf8acbb1ac03743221";
  };

  meta = {
    homepage = http://sourceforge.net/projects/ncompress/files/ncompress%20%28bugfixes%29/ncompress-4.2.4.2/ncompress-4.2.4.2.tar.gz/download;
  };
}
