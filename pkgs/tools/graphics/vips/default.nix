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
, meson
, ninja
, gtk-doc
, docbook-xsl-nons
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
, libspng
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
, cgif
}:

stdenv.mkDerivation rec {
  pname = "vips";
  version = "8.14.4";

  outputs = [ "bin" "out" "man" "dev" ] ++ lib.optionals (!stdenv.isDarwin) [ "devdoc" ];

  src = fetchFromGitHub {
    owner = "libvips";
    repo = "libvips";
    rev = "v${version}";
    hash = "sha256-y2Tyi8rxal3s3jLURRGPuCAUuHITRPl1+zJZDp557+I=";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    postFetch = ''
      rm -r $out/test/test-suite/images/
    '';
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    docbook-xsl-nons
    gobject-introspection
  ] ++ lib.optionals (!stdenv.isDarwin) [
    gtk-doc
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
    libspng
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
    cgif
  ] ++ lib.optionals stdenv.isDarwin [ ApplicationServices Foundation ];

  # Required by .pc file
  propagatedBuildInputs = [
    glib
  ];

  mesonFlags = [
    "-Dpdfium=disabled"
    "-Dnifti=disabled"
  ]
  ++ lib.optional (!stdenv.isDarwin) "-Dgtk_doc=true"
  ++ lib.optional (imagemagick == null) "-Dmagick=disabled"
  ;

  meta = with lib; {
    changelog = "https://github.com/libvips/libvips/blob/${src.rev}/ChangeLog";
    homepage = "https://libvips.github.io/libvips/";
    description = "Image processing system for large images";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ kovirobi ];
    platforms = platforms.unix;
  };
}
