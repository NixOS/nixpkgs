{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "unarj-2.63a";
  
  src = fetchurl {
    url = http://www.ibiblio.org/pub/Linux/utils/compress/unarj-2.63a.tar.gz;
    sha256 = "0j4sn57fq2p23pcq4ck06pm618q4vq09wgm89ilfn4c9l9x2ky1k";
  };

  preInstall = ''
    mkdir -p $out/bin
    sed -i -e s,/usr/local/bin,$out/bin, Makefile
  '';

  meta = {
    description = "Unarchiver of ARJ files";
    license = "free";
  };
}
