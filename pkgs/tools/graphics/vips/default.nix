{ stdenv, pkgconfig, glib, libxml2, expat,
  fftw, orc, lcms, imagemagick, openexr, libtiff, libjpeg, libgsf, libexif,
  ApplicationServices,
  python27, libpng ? null,
  fetchFromGitHub,
  autoreconfHook,
  gtk-doc,
  gobject-introspection,
}:

stdenv.mkDerivation rec {
  pname = "vips";
  version = "8.9.0";

  src = fetchFromGitHub {
    owner = "libvips";
    repo = "libvips";
    rev = "v${version}";
    sha256 = "0x61vnfnqv53pnp52nx610470x7pzdjbkqzk8wlc8i6cc2cg7f91";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    extraPostFetch = ''
      rm -r $out/test/test-suite/images/
    '';
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook gtk-doc gobject-introspection ];
  buildInputs = [ glib libxml2 fftw orc lcms
    imagemagick openexr libtiff libjpeg
    libgsf libexif python27 libpng expat ]
    ++ stdenv.lib.optional stdenv.isDarwin ApplicationServices;

  autoreconfPhase = ''
    ./autogen.sh
  '';

  meta = with stdenv.lib; {
    homepage = "https://libvips.github.io/libvips/";
    description = "Image processing system for large images";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ kovirobi ];
    platforms = platforms.unix;
  };
}
