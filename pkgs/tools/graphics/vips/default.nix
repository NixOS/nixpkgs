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
, libtiff
, fftw
, lcms2
, libspng
, libimagequant
, imagemagick
, pango
, matio
, cfitsio
, libwebp
, openexr
, openjpeg
, libjxl
, openslide
, libheif
, cgif
, libarchive
, libhwy
, testers
, nix-update-script
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vips";
  version = "8.15.3";

  outputs = [ "bin" "out" "man" "dev" ] ++ lib.optionals (!stdenv.isDarwin) [ "devdoc" ];

  src = fetchFromGitHub {
    owner = "libvips";
    repo = "libvips";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-VQtHHitEpxv63wC41TtRWLLCKHDAK7fbrS+cByeWxT0=";
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
    libtiff
    fftw
    lcms2
    libspng
    libimagequant
    imagemagick
    pango
    matio
    cfitsio
    libwebp
    openexr
    openjpeg
    libjxl
    openslide
    libheif
    cgif
    libarchive
    libhwy
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

  passthru = {
    tests = {
      pkg-config = testers.hasPkgConfigModules {
        package = finalAttrs.finalPackage;
      };
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        command = "vips --version";
      };
    };
    updateScript = nix-update-script {
      extraArgs = [ "--version-regex" "v([0-9.]+)" ];
    };
  };

  meta = with lib; {
    changelog = "https://github.com/libvips/libvips/blob/${finalAttrs.src.rev}/ChangeLog";
    homepage = "https://www.libvips.org/";
    description = "Image processing system for large images";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ kovirobi anthonyroussel ];
    pkgConfigModules = [ "vips" "vips-cpp" ];
    platforms = platforms.unix;
    mainProgram = "vips";
  };
})
