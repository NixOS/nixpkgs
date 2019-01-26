{ stdenv, fetchurl, pkgconfig, darwin, lib
, zlib, ghostscript, imagemagick, plotutils, gd
, libjpeg, libwebp, libiconv
}:

stdenv.mkDerivation rec {
  name = "pstoedit-3.73";

  src = fetchurl {
    url = "mirror://sourceforge/pstoedit/${name}.tar.gz";
    sha256 = "147jkgvm9n6mbkl6ndqnm9x74x5y9agbxkfwj0jrw6yxyhxx2cdd";
  };

  #
  # Turn on "-rdb" option (REALLYDELAYBIND) by default to ensure compatibility with gs-9.22
  #
  patches = [ ./pstoedit-gs-9.22-compat.patch  ];

  outputs = [ "out" "dev" ];
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ zlib ghostscript imagemagick plotutils gd libjpeg libwebp ]
  ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    libiconv ApplicationServices
  ]);

  # '@LIBPNG_LDFLAGS@' is no longer substituted by autoconf (the code is commented out)
  # so we need to remove it from the pkg-config file as well
  preConfigure = ''
    substituteInPlace config/pstoedit.pc.in --replace '@LIBPNG_LDFLAGS@' ""
  '';

  meta = with stdenv.lib; {
    description = "Translates PostScript and PDF graphics into other vector formats";
    homepage = https://sourceforge.net/projects/pstoedit/;
    license = licenses.gpl2;
    maintainers = [ maintainers.marcweber ];
    platforms = platforms.unix;
  };
}
