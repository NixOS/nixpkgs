{ stdenv, lib, fetchurl, fetchpatch, pkgconfig, zlib, expat, openssl, autoconf
, libjpeg, libpng, libtiff, freetype, fontconfig, lcms2, libpaper, jbig2dec
, libiconv, ijs
, x11Support ? false, xlibsWrapper ? null
, cupsSupport ? false, cups ? null
}:

assert x11Support -> xlibsWrapper != null;
assert cupsSupport -> cups != null;
let
  version = "9.20";
  sha256 = "1az0dnvgingqv78yvfhzmx1zavn5sv1xrrscz984hy3gvz2ks3rw";

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
  name = "ghostscript-${version}";

  src = fetchurl {
    url = "https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs920/${name}.tar.xz";
    inherit sha256;
  };

  outputs = [ "out" "man" "doc" ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgconfig autoconf ];
  buildInputs =
    [ zlib expat openssl
      libjpeg libpng libtiff freetype fontconfig lcms2 libpaper jbig2dec
      libiconv ijs
    ]
    ++ lib.optional x11Support xlibsWrapper
    ++ lib.optional cupsSupport cups
    ;

  patches = [
    ./urw-font-files.patch
  ];

  preConfigure = ''
    # requires in-tree (heavily patched) openjpeg
    rm -rf jpeg libpng zlib jasper expat tiff lcms{,2} jbig2dec freetype cups/libs ijs

    sed "s@if ( test -f \$(INCLUDE)[^ ]* )@if ( true )@; s@INCLUDE=/usr/include@INCLUDE=/no-such-path@" -i base/unix-aux.mak
    sed "s@^ZLIBDIR=.*@ZLIBDIR=${zlib.dev}/include@" -i configure.ac

    autoconf
  '' + lib.optionalString cupsSupport ''
    configureFlags="$configureFlags --with-cups-serverbin=$out/lib/cups --with-cups-serverroot=$out/etc/cups --with-cups-datadir=$out/share/cups"
  '';

  configureFlags =
    [ "--with-system-libtiff"
      "--enable-dynamic"
    ] ++ lib.optional x11Support "--with-x"
      ++ lib.optional cupsSupport "--enable-cups";

  doCheck = true;

  # don't build/install statically linked bin/gs
  buildFlags = [ "so" ];
  installTargets = [ "soinstall" ];

  postInstall = ''
    ln -s gsc "$out"/bin/gs

    cp -r Resource "$out/share/ghostscript/${version}"

    mkdir -p "$doc/share/ghostscript/${version}"
    mv "$out/share/ghostscript/${version}"/{doc,examples} "$doc/share/ghostscript/${version}/"

    ln -s "${fonts}" "$out/share/ghostscript/fonts"
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    for file in $out/lib/*.dylib* ; do
      install_name_tool -id "$file" $file
    done
  '';

  preFixup = lib.optionalString stdenv.isDarwin ''
    install_name_tool -change libgs.dylib.${version} $out/lib/libgs.dylib.${version} $out/bin/gs
  '';

  passthru = { inherit version; };

  meta = {
    homepage = http://www.ghostscript.com/;
    description = "PostScript interpreter (mainline version)";

    longDescription = ''
      Ghostscript is the name of a set of tools that provides (i) an
      interpreter for the PostScript language and the PDF file format,
      (ii) a set of C procedures (the Ghostscript library) that
      implement the graphics capabilities that appear as primitive
      operations in the PostScript language, and (iii) a wide variety
      of output drivers for various file formats and printers.
    '';

    license = stdenv.lib.licenses.gpl3Plus;

    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.viric ];
  };
}
