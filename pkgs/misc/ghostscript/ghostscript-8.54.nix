{ stdenv, fetchurl, libjpeg, libpng, zlib
, x11Support, x11 ? null
}:

assert x11Support -> x11 != null;

stdenv.mkDerivation {
  name = "ghostscript-8.54";
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/ghostscript/ghostscript-8.54-gpl.tar.bz2;
    md5 = "5d0ad0da8297fe459a788200f0eaeeba";
  };

  fonts = [
    (fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/ghostscript-fonts-std-8.11.tar.gz;
      md5 = "6865682b095f8c4500c54b285ff05ef6";
    })
    # ... add other fonts here
  ];

  buildInputs = [
    libjpeg libpng zlib
    (if x11Support then x11 else null)
  ];

  configureFlags = if x11Support then "--with-x" else "--without-x";
}
