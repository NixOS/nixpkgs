{ config
, stdenv
, lib
, fetchurl
, pkg-config
, zlib
, expat
, openssl
, autoconf
, libjpeg
, libpng
, libtiff
, freetype
, fontconfig
, libpaper
, jbig2dec
, libiconv
, ijs
, lcms2
, callPackage
, bash
, buildPackages
, openjpeg
, cupsSupport ? config.ghostscript.cups or (!stdenv.isDarwin)
, cups
, x11Support ? cupsSupport
, xorg # with CUPS, X11 only adds very little
, dynamicDrivers ? true

# for passthru.tests
, graphicsmagick
, imagemagick
, libspectre
, lilypond
, pstoedit
, python3
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
  pname = "ghostscript${lib.optionalString x11Support "-with-X"}";
  version = "10.01.2";

  src = fetchurl {
    url = "https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs${lib.replaceStrings ["."] [""] version}/ghostscript-${version}.tar.xz";
    hash = "sha512-7iDw4S9VOj0EV45xoNRd7+vHERfOTcLBQEOYW/5zSK1/iy/pj8m09bk17LMuUNw0C+Z9bvWBkFQuxtD52h3jgA==";
  };

  patches = [
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
    libiconv ijs lcms2 bash openjpeg
  ]
  ++ lib.optionals x11Support [ xorg.libICE xorg.libX11 xorg.libXext xorg.libXt ]
  ++ lib.optional cupsSupport cups
  ;

  preConfigure = ''
    # https://ghostscript.com/doc/current/Make.htm
    export CCAUX=$CC_FOR_BUILD
    ${lib.optionalString cupsSupport ''export CUPSCONFIG="${cups.dev}/bin/cups-config"''}

    rm -rf jpeg libpng zlib jasper expat tiff lcms2mt jbig2dec freetype cups/libs ijs openjpeg

    sed "s@if ( test -f \$(INCLUDE)[^ ]* )@if ( true )@; s@INCLUDE=/usr/include@INCLUDE=/no-such-path@" -i base/unix-aux.mak
    sed "s@^ZLIBDIR=.*@ZLIBDIR=${zlib.dev}/include@" -i configure.ac

    autoconf
  '';

  configureFlags = [
    "--with-system-libtiff"
    "--without-tesseract"
  ] ++ lib.optionals dynamicDrivers [
    "--enable-dynamic"
    "--disable-hidden-visibility"
  ] ++ lib.optionals x11Support [
    "--with-x"
  ] ++ lib.optionals cupsSupport [
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
    install_name_tool -change libgs.dylib.$dylib_version $out/lib/libgs.dylib.$dylib_version $out/bin/gsx
  '';

  # validate dynamic linkage
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/gs --version
    $out/bin/gsx --version
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

  passthru.tests = {
    test-corpus-render = callPackage ./test-corpus-render.nix {};
    inherit graphicsmagick imagemagick libspectre lilypond pstoedit;
    inherit (python3.pkgs) matplotlib;
  };

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
