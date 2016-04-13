{ stdenv, lib, fetchurl, fetchpatch, pkgconfig, zlib, expat, openssl, autoconf
, libjpeg, libpng, libtiff, freetype, fontconfig, lcms2, libpaper, jbig2dec
, libiconv, ijs
, x11Support ? false, xlibsWrapper ? null
, cupsSupport ? false, cups ? null
}:

assert x11Support -> xlibsWrapper != null;
assert cupsSupport -> cups != null;
let
  version = "9.18";
  sha256 = "18ad90za28dxybajqwf3y3dld87cgkx1ljllmcnc7ysspfxzbnl3";

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
    url = "http://downloads.ghostscript.com/public/${name}.tar.bz2";
    inherit sha256;
  };

  outputs = [ "out" "doc" ];

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
    # http://bugs.ghostscript.com/show_bug.cgi?id=696281
    (fetchpatch {
      name = "fix-check-for-using-shared-freetype-lib.patch";
      url = "http://git.ghostscript.com/?p=ghostpdl.git;a=patch;h=8f5d285";
      sha256 = "1f0k043rng7f0rfl9hhb89qzvvksqmkrikmm38p61yfx51l325xr";
    })
    # http://bugs.ghostscript.com/show_bug.cgi?id=696301
    (fetchpatch {
      name = "add-gserrors.h-to-the-installed-files.patch";
      url = "http://git.ghostscript.com/?p=ghostpdl.git;a=patch;h=feafe5e5";
      sha256 = "0s4ayzakjv809dkn7vilxwvs4dw35p3pw942ml91bk9z4kkaxyz7";
    })
    # http://bugs.ghostscript.com/show_bug.cgi?id=696246
    (fetchpatch {
      name = "guard-against-NULL-base-for-non-clist-devices.patch";
      url = "http://git.ghostscript.com/?p=ghostpdl.git;a=patch;h=007bd77d08d800e6b07274d62e3c91be7c4a3f47";
      sha256 = "1la53273agl92lpy7qd0qhgzynx8b90hrk8g9jsj3055ssn6rqwh";
    })
    (fetchpatch {
      name = "ensure-plib-devices-always-use-the-clist.patch";
      url = "http://git.ghostscript.com/?p=ghostpdl.git;a=patch;h=1bdbe4f87dc57648821e613ebcc591b84e8b35b3";
      sha256 = "1cq83fgyvrycapxm69v4r9f9qhzsr40ygrc3bkp8pk15wsmvq0k7";
    })
    (fetchpatch {
      name = "prevent-rinkj-device-crash-when-misconfigured.patch";
      url = "http://git.ghostscript.com/?p=ghostpdl.git;a=patch;h=5571ddfa377c5d7d98f55af40e693814ac287ae4";
      sha256 = "08iqdlrngi6k0ml2b71dj5q136fyp1s9g0rr87ayyshn0k0lxwkv";
    })
  ];

  preConfigure = ''
    # requires in-tree (heavily patched) openjpeg
    rm -rf jpeg libpng zlib jasper expat tiff lcms{,2} jbig2dec freetype cups/libs ijs

    sed "s@if ( test -f \$(INCLUDE)[^ ]* )@if ( true )@; s@INCLUDE=/usr/include@INCLUDE=/no-such-path@" -i base/unix-aux.mak
    sed "s@^ZLIBDIR=.*@ZLIBDIR=${zlib}/include@" -i configure.ac

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
  '';

  preFixup = lib.optionalString stdenv.isDarwin ''
    install_name_tool -change libgs.dylib.${version} $out/lib/libgs.dylib.${version} $out/bin/gs
  '';

  meta = {
    homepage = "http://www.ghostscript.com/";
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
