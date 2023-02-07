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
  version = "8.14.1";

  outputs = [ "bin" "out" "man" "dev" "devdoc" ];

  src = fetchFromGitHub {
    owner = "libvips";
    repo = "libvips";
    rev = "v${version}";
    hash = "sha256-ajGVSVjnv78S/Xd3Aqn0N87I7m39DWKZHAQjwbog+5U=";
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
    gtk-doc
    docbook-xsl-nons
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

  mesonFlags = [
    "-Dgtk_doc=true"
    "-Dcgif=disabled"
    "-Dspng=disabled"
    "-Dpdfium=disabled"
    "-Dnifti=disabled"
  ];

  meta = with lib; {
    changelog = "https://github.com/libvips/libvips/blob/${src.rev}/ChangeLog";
    homepage = "https://libvips.github.io/libvips/";
    description = "Image processing system for large images";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ kovirobi ];
    platforms = platforms.unix;
  };
}
