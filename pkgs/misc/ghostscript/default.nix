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
  ver_min = "26";
  sha512 = "0z2mvsh06qgnxl7p9isw7swg8jp8xcx3rnbqk727avw7ammvfh8785d2bn5i4fhz8y45ka3cpgp7b598m06yq5zawijhcnzkq187nrx";

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
      name = "CVE-2019-6116";
      url = "http://git.ghostscript.com/?p=ghostpdl.git;a=patch;h=d3537a54740d78c5895ec83694a07b3e4f616f61";
      sha256 = "1hr8bpi87bbg1kvv28kflmfh1dhzxw66p9q0ddvbrj72qd86p3kx";
    })
    ./9.26-CVE-2019-3835-part-1.patch
    ./9.26-CVE-2019-3835-part-2.patch
    ./9.26-CVE-2019-3835-part-3.patch
    ./9.26-CVE-2019-3835-part-4.patch
    ./9.26-CVE-2019-3838-part-1.patch
    ./9.26-CVE-2019-3838-part-2.patch
    (fetchpatch {
      name = "CVE-2019-3839-part-1";
      url = "http://git.ghostscript.com/?p=ghostpdl.git;a=patch;h=4ec9ca74bed49f2a82acb4bf430eae0d8b3b75c9";
      sha256 = "0gn1n9fq5msrxxzspidcnmykp1iv3yvx5485fddmgrslr52ngcf9";
    })
    (fetchpatch {
      name = "CVE-2019-3839-part-2";
      url = "http://git.ghostscript.com/?p=ghostpdl.git;a=patch;h=db24f253409d5d085c2760c814c3e1d3fa2dac59";
      sha256 = "1h6kpwc6ryr6jlxjr6bfnvmmf8x0kqmyjlx3hggqjs23n0wsr9p9";
    })
    ./9.26-CVE-2019-10216.patch
    (fetchpatch {
        name = "CVE-2019-14811.CVE-2019-14812.CVE-2019-14813.patch";
        url = "https://git.ghostscript.com/?p=ghostpdl.git;a=patch;h=885444fcbe10dc42787ecb76686c8ee4dd33bf33";
        sha256 = "19928sr7xpx7iibk9gn127g0r1yv2lcfpwgk2ipzz4wgrs3f5j70";
    })
    (fetchpatch {
        name = "CVE-2019-14817-partial.patch";
        url = "https://git.ghostscript.com/?p=ghostpdl.git;a=patch;h=cd1b1cacadac2479e291efe611979bdc1b3bdb19";
        # patch doesn't apply cleanly to all files, but at least partially applying it fixes
        # *some* of the problematic sites.
        excludes = ["Resource/Init/pdf_font.ps" "Resource/Init/pdf_draw.ps"];
        sha256 = "04sy05svm3d2hyyzq41x5aqg3cgg2shaq08ivdqsys95nlihccpn";
    })
    ./9.26-CVE-2019-14869.patch
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
