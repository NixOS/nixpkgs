{ stdenv, lib, fetchzip,
  autoconf, automake, libtool,
  cups, popt, libtiff, libpng,
  ghostscript, glib, libusb, libxml2,
  gtk2, pkg-config }:

/* this derivation is basically just a transcription of the rpm .spec
   file included in the tarball */

let arch =
  if stdenv.hostPlatform.system == "x86_64-linux" then "64"
    else throw "Unsupported system ${stdenv.hostPlatform.system}";
  models = "mp230 mg2200 e510 mg3200 mg4200 ip7200 mg5400 mg6300";
  numbers = "401 402 403 404 405 406 407 408";

in stdenv.mkDerivation {
  pname = "cnijfilter";

  /* important note about versions: cnijfilter packages seem to use
     versions in a non-standard way.  the version indicates which
     printers are supported in the package.  so this package should
     not be "upgraded" in the usual way.

     instead, if you want to include another version supporting your
     printer, you should try to abstract out the common things (which
     should be pretty much everything except the version and the 'pr'
     and 'pr_id' values to loop over). */
  version = "3.80";

  src = fetchzip {
    url = "http://gdlp01.c-wss.com/gds/3/0100004693/01/cnijfilter-source-3.80-1.tar.gz";
    sha256 = "03v4yn346xn4hk498lzz8ykdbhd4l8qna909fmr0qrkypyhd4627";
  };

  buildInputs = [ autoconf libtool automake
                  cups popt libtiff libpng
                  ghostscript glib libusb libxml2
                  gtk2 pkg-config ];

  # patches from https://github.com/tokiclover/bar-overlay/tree/master/net-print/cnijfilter
  patches = [
    ./patches/cnijfilter-3.80-1-cups-1.6.patch
    ./patches/cnijfilter-3.80-6-cups-1.6.patch
  ];

  postPatch = ''
    sed -i "s|/usr/lib/cups/backend|$out/lib/cups/backend|" backend/src/Makefile.am;
    sed -i "s|/usr/lib/cups/backend|$out/lib/cups/backend|" backendnet/backend/Makefile.am;
    sed -i "s|/usr|$out|" backend/src/cnij_backend_common.c;
    sed -i "s|/usr/bin|${ghostscript}/bin|" pstocanonij/filter/pstocanonij.c;
  '';

  configurePhase = ''
    cd libs
    ./autogen.sh --prefix=$out

    cd ../cngpij
    ./autogen.sh --prefix=$out --enable-progpath=$out/bin

    cd ../cngpijmnt
    ./autogen.sh --prefix=$out --enable-progpath=$out/bin

    cd ../pstocanonij
    ./autogen.sh --prefix=$out --enable-progpath=$out/bin

    cd ../backend
    ./autogen.sh --prefix=$out

    cd ../backendnet
    ./autogen.sh --prefix=$out --enable-libpath=$out/lib/bjlib --enable-progpath=$out/bin

    cd ../cnijfilter
    ./autogen.sh --prefix=$out --enable-libpath=$out/lib/bjlib --enable-binpath=$out/bin

    cd ../maintenance
    ./autogen.sh --prefix=$out --datadir=$out/share --enable-libpath=$out/lib/bjlib

    cd ../lgmon
    ./autogen.sh --prefix=$out --enable-progpath=$out/bin

    cd ../cngpijmon
    ./autogen.sh --prefix=$out  --enable-progpath=$out/bin --datadir=$out/share

    cd ../cngpijmon/cnijnpr
    ./autogen.sh --prefix=$out --enable-libpath=$out/lib/bjlib
  '';

  preInstall = ''
    mkdir -p $out/bin $out/lib/cups/filter $out/share/cups/model;
  '';

  postInstall = ''
    set -o xtrace
    for pr in ${models}; do
      cd ppd;
      ./autogen.sh --prefix=$out --program-suffix=$pr
      make clean;
      make;
      make install;

      cd ../lgmon
      ./autogen.sh --prefix=$out --program-suffix=$pr --enable-progpath=$out/bin
      make clean;
      make;
      make install;

      cd ../cnijfilter;
      ./autogen.sh --prefix=$out --program-suffix=$pr --enable-libpath=/var/lib/cups/path/lib/bjlib --enable-binpath=$out/bin;
      make clean;
      make;
      make install;

      cd ../maintenance
      ./autogen.sh --prefix=$out --program-suffix=$pr --datadir=$out/share --enable-libpath=/var/lib/cups/path/lib/bjlib
      make clean;
      make;
      make install;

      cd ../cngpijmon
      ./autogen.sh --prefix=$out --program-suffix=$pr --enable-progpath=$out/bin --datadir=$out/share
      make clean;
      make;
      make install;

      cd ..;
    done;

    mkdir -p $out/lib/bjlib;
    for pr_id in ${numbers}; do
      install -c -m 755 $pr_id/database/* $out/lib/bjlib;
      install -c -s -m 755 $pr_id/libs_bin${arch}/*.so.* $out/lib;
    done;

    pushd $out/lib;
    for so_file in *.so.*; do
      ln -s $so_file ''${so_file/.so.*/}.so;
      patchelf --set-rpath $out/lib $so_file;
    done;
    popd;
  '';

  /* the tarball includes some pre-built shared libraries.  we run
     'patchelf --set-rpath' on them just a few lines above, so that
     they can find each other.  but that's not quite enough.  some of
     those libraries load each other in non-standard ways -- they
     don't list each other in the DT_NEEDED section.  so, if the
     standard 'patchelf --shrink-rpath' (from
     pkgs/development/tools/misc/patchelf/setup-hook.sh) is run on
     them, it undoes the --set-rpath.  this prevents that. */
  dontPatchELF = true;

  meta = with lib; {
    description = "Canon InkJet printer drivers for the ${models} series.";
    homepage = https://www.canon.co.uk/support/consumer_products/products/printers/inkjet/pixma_ip_series/pixma_ip7250.html?type=drivers&language=&os=linux;
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ turion ];
  };
}
