{ stdenv, lib, fetchurl, pkgconfig, zlib, expat, openssl, autoconf
, libjpeg, libpng, libtiff, freetype, fontconfig, libpaper, jbig2dec
, libiconv, ijs
, x11Support ? false, xlibsWrapper ? null
, cupsSupport ? false, cups ? null
}:

assert x11Support -> xlibsWrapper != null;
assert cupsSupport -> cups != null;
let
  version = "9.${ver_min}";
  ver_min = "24";
  # ghostscript*.tar.xz in https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs9xx/SHA512SUMS
  sha512 = "dcbeeb5d3dd5ccaf949dc4be68363c50b1d35e647be4790a50b1bbf5f259f1d9181f705be27bfca708c4d270f945ff4b24e3db10b57800c1ee0ea7a40931c547";

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
    url = "https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs9${ver_min}/${name}.tar.xz";
    inherit sha512;
  };

  patches = [
    ./urw-font-files.patch
    ./doc-no-ref.diff
  ];

  outputs = [ "out" "man" "doc" ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgconfig autoconf ];
  buildInputs =
    [ zlib expat openssl
      libjpeg libpng libtiff freetype fontconfig libpaper jbig2dec
      libiconv ijs
    ]
    ++ lib.optional x11Support xlibsWrapper
    ++ lib.optional cupsSupport cups
    ;
  # No lcms2; upstream "is in process of forking it" and thus won't use one from a library.

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

    mkdir -p "$doc/share/doc/ghostscript"
    mv "$doc/share/doc/${version}" "$doc/share/doc/ghostscript/"

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
    homepage = https://www.ghostscript.com/;
    description = "PostScript interpreter (mainline version)";

    longDescription = ''
      Ghostscript is the name of a set of tools that provides (i) an
      interpreter for the PostScript language and the PDF file format,
      (ii) a set of C procedures (the Ghostscript library) that
      implement the graphics capabilities that appear as primitive
      operations in the PostScript language, and (iii) a wide variety
      of output drivers for various file formats and printers.
    '';

    license = stdenv.lib.licenses.agpl3;

    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.viric ];
  };
}
