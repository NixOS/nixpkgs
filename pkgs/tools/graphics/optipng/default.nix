{ stdenv, fetchurl, libpng, static ? false
, buildPlatform, hostPlatform
}:

# This package comes with its own copy of zlib, libpng and pngxtern

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "optipng-0.7.6";

  src = fetchurl {
    url = "mirror://sourceforge/optipng/${name}.tar.gz";
    sha256 = "105yk5qykvhiahzag67gm36s2kplxf6qn5hay02md0nkrcgn6w28";
  };

  buildInputs = [ libpng ];

  LDFLAGS = optional static "-static";
  configureFlags = [
    "--with-system-zlib"
    "--with-system-libpng"
  ] ++ stdenv.lib.optionals (hostPlatform != buildPlatform) [
    #"-prefix=$out"
  ];

  postInstall = if hostPlatform != buildPlatform && hostPlatform.isWindows then ''
    mv "$out"/bin/optipng{,.exe}
  '' else null;

  meta = with stdenv.lib; {
    homepage = http://optipng.sourceforge.net/;
    description = "A PNG optimizer";
    license = licenses.zlib;
    platforms = platforms.unix;
  };
}
