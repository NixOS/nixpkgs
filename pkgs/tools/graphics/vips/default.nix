{ stdenv
, pkgconfig
, glib
, libxml2
, expat
, fftw
, orc
, lcms
, imagemagick
, openexr
, libtiff
, libjpeg
, libgsf
, libexif
, libheif
, ApplicationServices
, python27
, libpng
, fetchFromGitHub
, fetchpatch
, autoreconfHook
, gtk-doc
, gobject-introspection
,
}:

stdenv.mkDerivation rec {
  pname = "vips";
  version = "8.9.2";

  outputs = [ "bin" "out" "man" "dev" ];

  src = fetchFromGitHub {
    owner = "libvips";
    repo = "libvips";
    rev = "v${version}";
    sha256 = "0pgvcp5yjk96izh7kjfprjd9kddx7zqrwwhm8dyalhrwbmj6c2q5";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    extraPostFetch = ''
      rm -r $out/test/test-suite/images/
    '';
  };

  nativeBuildInputs = [
    pkgconfig
    autoreconfHook
    gtk-doc
    gobject-introspection
  ];

  buildInputs = [
    glib
    libxml2
    fftw
    orc
    lcms
    imagemagick
    openexr
    libtiff
    libjpeg
    libgsf
    libexif
    libheif
    libpng
    python27
    libpng
    expat
  ] ++ stdenv.lib.optional stdenv.isDarwin ApplicationServices;

  # Required by .pc file
  propagatedBuildInputs = [
    glib
  ];

  autoreconfPhase = ''
    NOCONFIGURE=1 ./autogen.sh
  '';

  meta = with stdenv.lib; {
    homepage = "https://libvips.github.io/libvips/";
    description = "Image processing system for large images";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ kovirobi ];
    platforms = platforms.unix;
  };
}
