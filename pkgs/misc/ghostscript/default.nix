{stdenv, fetchurl, libjpeg, libpng, zlib}:

stdenv.mkDerivation {
  name = "ghostscript-8.15";
  builder = ./builder.sh;
  
  src = fetchurl {
    url = ftp://mirror.cs.wisc.edu/pub/mirrors/ghost/GPL/gs815/ghostscript-8.15.tar.bz2;
    md5 = "ab8502f30629b730e0c9ca56b88a6b9d";
  };

  fonts = [
    (fetchurl {
      url = ftp://mirror.cs.wisc.edu/pub/mirrors/ghost/GPL/gs815/ghostscript-fonts-std-8.11.tar.gz;
      md5 = "6865682b095f8c4500c54b285ff05ef6";
    })
    # ... add other fonts here
  ];

  buildInputs = [libjpeg libpng zlib];

  configureFlags = "--without-x";
}
