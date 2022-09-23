{ lib
, stdenv
, pkg-config
, glib
, libxml2
, expat
, ApplicationServices
, Foundation
, python3
, fetchFromGitHub
, fetchpatch
, autoreconfHook
, gtk-doc
, gobject-introspection
  # Optional dependencies
, libjpeg
, libexif
, librsvg
, poppler
, libgsf
, libtiff
, fftw
, lcms2
, libpng
, libimagequant
, imagemagick
, pango
, orc
, matio
, cfitsio
, libwebp
, openexr
, openjpeg
, libjxl
, openslide
, libheif
}:

stdenv.mkDerivation rec {
  pname = "vips";
  version = "8.13.0";

  outputs = [ "bin" "out" "man" "dev" ];

  src = fetchFromGitHub {
    owner = "libvips";
    repo = "libvips";
    rev = "v${version}";
    sha256 = "sha256-N2jq68Vs/D+lZcIJVdjBLVaz2gK/TwqKeNfHUWdS3NA=";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    postFetch = ''
      rm -r $out/test/test-suite/images/
    '';
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    gtk-doc
    gobject-introspection
  ];

  buildInputs = [
    glib
    libxml2
    expat
    (python3.withPackages (p: [ p.pycairo ]))
    # Optional dependencies
    libjpeg
    libexif
    librsvg
    poppler
    libgsf
    libtiff
    fftw
    lcms2
    libpng
    libimagequant
    imagemagick
    pango
    orc
    matio
    cfitsio
    libwebp
    openexr
    openjpeg
    libjxl
    openslide
    libheif
  ] ++ lib.optionals stdenv.isDarwin [ ApplicationServices Foundation ];

  # Required by .pc file
  propagatedBuildInputs = [
    glib
  ];

  autoreconfPhase = ''
    NOCONFIGURE=1 ./autogen.sh
  '';

  meta = with lib; {
    homepage = "https://libvips.github.io/libvips/";
    description = "Image processing system for large images";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ kovirobi ];
    platforms = platforms.unix;
  };
}
