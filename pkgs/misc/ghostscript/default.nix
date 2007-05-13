{ stdenv, fetchurl, libjpeg, libpng, zlib
, x11Support, x11 ? null
}:

assert x11Support -> x11 != null;

stdenv.mkDerivation {
  name = "ghostscript-8.56";
  builder = ./builder.sh;
  
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/ghostscript/gnu-ghostscript-8.56.0.tar.bz2;
    sha256 = "12wkxqf661i9wpcyjj9kp69r4gix7crji52f21s49slqjmbc0f3s";
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

  configureFlags = "
    ${if x11Support then "--with-x" else "--without-x"}
  ";

  # This patch is required to make Ghostscript at least build in a pure 
  # environment (like NixOS).  Ghostscript's build process performs 
  # various tests for the existence of files in /usr/include.
  patches = [ ./purity.patch ];
}
