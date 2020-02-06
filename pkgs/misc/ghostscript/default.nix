{ config, stdenv, lib, fetchurl, pkgconfig, zlib, expat, openssl, autoconf
, libjpeg, libpng, libtiff, freetype, fontconfig, libpaper, jbig2dec
, libiconv, ijs, lcms2, fetchpatch
, cupsSupport ? config.ghostscript.cups or (!stdenv.isDarwin), cups ? null
, x11Support ? cupsSupport, xlibsWrapper ? null # with CUPS, X11 only adds very little
}:

assert x11Support -> xlibsWrapper != null;
assert cupsSupport -> cups != null;

let
  version = "9.${ver_min}";
  ver_min = "50";
  sha512 = "3p46kzn6kh7z4qqnqydmmvdlgzy5730z3yyvyxv6i4yb22mgihzrwqmhmvfn3b7lypwf6fdkkndarzv7ly3zndqpyvg89x436sms7iw";

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
  inherit version;

  src = fetchurl {
    url = "https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs9${ver_min}/${pname}-${version}.tar.xz";
    inherit sha512;
  };

  patches = [
    ./urw-font-files.patch
    ./doc-no-ref.diff
    (fetchpatch {
      name = "CVE-2019-14869.patch";
      url = "https://git.ghostscript.com/?p=ghostpdl.git;a=patch;h=485904772c5f0aa1140032746e5a0abfc40f4cef";
      sha256 = "0z5gnvgpp0dlzgvpw9a1yan7qyycv3mf88l93fvb1kyay893rshp";
    })
  ];

  outputs = [ "out" "man" "doc" ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgconfig autoconf ];
  buildInputs =
    [ zlib expat openssl
      libjpeg libpng libtiff freetype fontconfig libpaper jbig2dec
      libiconv ijs lcms2
    ]
    ++ lib.optional x11Support xlibsWrapper
    ++ lib.optional cupsSupport cups
    ;

  preConfigure = ''
    # requires in-tree (heavily patched) openjpeg
    rm -rf jpeg libpng zlib jasper expat tiff lcms2mt jbig2dec freetype cups/libs ijs

    sed "s@if ( test -f \$(INCLUDE)[^ ]* )@if ( true )@; s@INCLUDE=/usr/include@INCLUDE=/no-such-path@" -i base/unix-aux.mak
    sed "s@^ZLIBDIR=.*@ZLIBDIR=${zlib.dev}/include@" -i configure.ac

    autoconf
  '';

  configureFlags = [
    "--with-system-libtiff"
    "--enable-dynamic"
  ]
  ++ lib.optional x11Support "--with-x"
  ++ lib.optionals cupsSupport [
    "--enable-cups"
    "--with-cups-serverbin=$(out)/lib/cups"
    "--with-cups-serverroot=$(out)/etc/cups"
    "--with-cups-datadir=$(out)/share/cups"
  ];

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
