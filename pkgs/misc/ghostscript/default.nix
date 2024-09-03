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
        hash = "sha256-DrbzVhGfLkmyVjIQhS4X9X+dzFdV81Cmmkag1kGgxAE=";
      })
      (fetchurl {
        url = "mirror://gnu/ghostscript/gnu-gs-fonts-other-6.0.tar.gz";
        hash = "sha256-gUbMzEaZ/p2rhBRGvdFwOfR2nJA+zrVECRiLkgdUqrM=";
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
  version = "10.03.1";

  src = fetchurl {
    url = "https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs${lib.replaceStrings ["."] [""] version}/ghostscript-${version}.tar.xz";
    hash = "sha256-FXIS7clrjMxAlHXc4uSYM/tEJ/FQxFUlje2WMsEGq+4=";
  };

  patches = [
    ./urw-font-files.patch
    ./doc-no-ref.diff
  ];

  outputs = [ "out" "man" "doc" "fonts" ];

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
  buildFlags = [ "so" ]
    # without -headerpad, the following error occurs on Darwin when compiling with X11 support (as of 10.02.0)
    # error: install_name_tool: changing install names or rpaths can't be redone for: [...]libgs.dylib.10 (the program must be relinked, and you may need to use -headerpad or -headerpad_max_install_names)
    ++ lib.optional (x11Support && stdenv.isDarwin) "LDFLAGS=-headerpad_max_install_names";
  installTargets = [ "soinstall" ];

  postInstall = ''
    ln -s gsc "$out"/bin/gs

    cp -r Resource "$out/share/ghostscript/${version}"

    mkdir -p $fonts/share/fonts
    cp -rv ${fonts}/* "$fonts/share/fonts/"
    ln -s "$fonts/share/fonts" "$out/share/ghostscript/fonts"
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
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.tobim ];
    mainProgram = "gs";
  };
}
