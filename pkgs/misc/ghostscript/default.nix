{ config, stdenv, lib, fetchurl, pkg-config, zlib, expat, openssl, autoconf
, libjpeg, libpng, libtiff, freetype, fontconfig, libpaper, jbig2dec
, libiconv, ijs, lcms2, fetchpatch, callPackage, bash, buildPackages
, cupsSupport ? config.ghostscript.cups or (!stdenv.isDarwin), cups
, x11Support ? cupsSupport, xlibsWrapper # with CUPS, X11 only adds very little
}:

let
  fonts = stdenv.mkDerivation {
    name = "ghostscript-fonts";

    srcs = [
      (fetchurl {
        url = "mirror://sourceforge/gs-fonts/ghostscript-fonts-std-8.11.tar.gz";
        sha256 = "00f4l10xd826kak51wsmaz69szzm2wp8a41jasr4jblz25bg7dhf";
      })
      (fetchurl {
        url = "mirror://gnu/ghostscript/gnu-gs-fonts-other-6.0.tar.gz";
        sha256 = "1cxaah3r52qq152bbkiyj2f7dx1rf38vsihlhjmrvzlr8v6cqil1";
      })
      # ... add other fonts here
    ];

    installPhase = ''
      mkdir "$out"
      mv -v * "$out/"
    '';
  };

in
stdenv.mkDerivation rec {
  pname = "ghostscript";
  version = "9.55.0";

  src = fetchurl {
    url = "https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs9${lib.versions.minor version}${lib.versions.patch version}/${pname}-${version}.tar.xz";
    sha512 = "27g72152mlwlalg232jxdhaf3ykgmqwi2pccbkwfygql1h9iz40plfbwbs1n0fkvm4zwzg5r9cr8g7w2dxih4jldiidv7rflxdy1is2";
  };

  patches = [
    (fetchpatch {
      name = "fix-non-vendored-lcms2-typo.patch";
      url = "https://github.com/ArtifexSoftware/ghostpdl/commit/830afae5454dea3bff903869d82022306890a96c.patch";
      sha256 = "1w9yspsgxyabvrw9ld6pv6pb7708c44ihjqvag7qqh9v1lhm48j0";
    })
    ./urw-font-files.patch
    ./doc-no-ref.diff
  ];

  outputs = [ "out" "man" "doc" ];

  enableParallelBuilding = true;

  depsBuildBuild = [
    buildPackages.stdenv.cc
  ];

  nativeBuildInputs = [ pkg-config autoconf zlib ]
    ++ lib.optional cupsSupport cups;

  buildInputs = [
    zlib expat openssl
    libjpeg libpng libtiff freetype fontconfig libpaper jbig2dec
    libiconv ijs lcms2 bash
  ]
  ++ lib.optional x11Support xlibsWrapper
  ++ lib.optional cupsSupport cups
  ;

  preConfigure = ''
    # https://ghostscript.com/doc/current/Make.htm
    export CCAUX=$CC_FOR_BUILD
    ${lib.optionalString cupsSupport ''export CUPSCONFIG="${cups.dev}/bin/cups-config"''}

    # requires in-tree (heavily patched) openjpeg
    rm -rf jpeg libpng zlib jasper expat tiff lcms2mt jbig2dec freetype cups/libs ijs

    sed "s@if ( test -f \$(INCLUDE)[^ ]* )@if ( true )@; s@INCLUDE=/usr/include@INCLUDE=/no-such-path@" -i base/unix-aux.mak
    sed "s@^ZLIBDIR=.*@ZLIBDIR=${zlib.dev}/include@" -i configure.ac

    autoconf
  '';

  configureFlags = [
    "--with-system-libtiff"
    "--enable-dynamic"
    "--without-tesseract"
  ]
  ++ lib.optional x11Support "--with-x"
  ++ lib.optionals cupsSupport [
    "--enable-cups"
  ];

  # make check does nothing useful
  doCheck = false;

  # don't build/install statically linked bin/gs
  buildFlags = [ "so" ];
  installTargets = [ "soinstall" ];

  postInstall = ''
    ln -s gsc "$out"/bin/gs

    cp -r Resource "$out/share/ghostscript/${version}"

    ln -s "${fonts}" "$out/share/ghostscript/fonts"
  '' + lib.optionalString stdenv.isDarwin ''
    for file in $out/lib/*.dylib* ; do
      install_name_tool -id "$file" $file
    done
  '';

  # dynamic library name only contains maj.min, eg. '9.53'
  dylib_version = lib.versions.majorMinor version;
  preFixup = lib.optionalString stdenv.isDarwin ''
    install_name_tool -change libgs.dylib.$dylib_version $out/lib/libgs.dylib.$dylib_version $out/bin/gs
  '';

  # validate dynamic linkage
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/gs --version
    pushd examples
    for f in *.{ps,eps,pdf}; do
      echo "Rendering $f"
      $out/bin/gs \
        -dNOPAUSE \
        -dBATCH \
        -sDEVICE=bitcmyk \
        -sOutputFile=/dev/null \
        -r600 \
        -dBufferSpace=100000 \
        $f
    done
    popd # examples

    runHook postInstallCheck
  '';

  passthru.tests.test-corpus-render = callPackage ./test-corpus-render.nix {};

  meta = {
    homepage = "https://www.ghostscript.com/";
    description = "PostScript interpreter (mainline version)";
    longDescription = ''
      Ghostscript is the name of a set of tools that provides (i) an
      interpreter for the PostScript language and the PDF file format,
      (ii) a set of C procedures (the Ghostscript library) that
      implement the graphics capabilities that appear as primitive
      operations in the PostScript language, and (iii) a wide variety
      of output drivers for various file formats and printers.
    '';
    license = lib.licenses.agpl3;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.viric ];
    mainProgram = "gs";
  };
}
