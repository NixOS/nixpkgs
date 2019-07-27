{ stdenv, lib, fetchpatch, fetchzip,
  autoconf, automake, libtool, gtk2,
  cups, popt, libtiff, libpng, pkg-config,
  ghostscript, glib, libusb, libxml2 }:

/* this derivation is basically just a transcription of the rpm .spec
   file included in the tarball */

let arch =
      if stdenv.hostPlatform.system == "x86_64-linux" then "64"
      else if stdenv.hostPlatform.system == "i686-linux" then "32"
      else throw "Unsupported system ${stdenv.hostPlatform.system}";

in stdenv.mkDerivation rec {
  name = "cnijfilter-${version}";

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

  nativeBuildInputs = [ autoconf automake libtool pkg-config ];
  buildInputs = [ cups popt libtiff libpng gtk2
                  ghostscript glib libusb libxml2 ];

  # patches from https://github.com/tokiclover/bar-overlay/tree/master/net-print/cnijfilter
  patches = [
    (fetchpatch {
      url = "https://gitlab.com/tokiclover/bar-overlay/-/raw/6ef05309c0890fd7620092d3ec7ffa1d068b13f9/net-print/cnijfilter/files/cnijfilter-3.80-1-cups-1.6.patch";
      name = "cnijfilter-3.80-1-cups-1.6.patch";
      sha256 = "0sv5ixxa72dhm86shfbaidiyxx3cm6a5wsi6nklpmjf5fz621gwy";
    })
    (fetchpatch {
      url = "https://gitlab.com/tokiclover/bar-overlay/-/raw/6ef05309c0890fd7620092d3ec7ffa1d068b13f9/net-print/cnijfilter/files/cnijfilter-3.80-6-cups-1.6.patch";
      name = "cnijfilter-3.80-6-cups-1.6.patch";
      sha256 = "09l9zq6l0xnb2nbf9yrnkhhl218ja0kid8bqfjjqvqj5d9lb7pd4";
    })
    (fetchpatch {
      url = "https://gitlab.com/tokiclover/bar-overlay/-/raw/6ef05309c0890fd7620092d3ec7ffa1d068b13f9/net-print/cnijfilter/files/cnijfilter-3.80-6-headers.patch";
      name = "cnijfilter-3.80-6-headers.patch";
      sha256 = "136f2gm44xz47cln8s4laks4dy5ql2dwqvv20mybl6jpcxflkkj5";
    })
    ./patches/abi_x86_32.patch
    ./patches/ppd.patch
    ./patches/libpng15.patch
    ./patches/missing_paren.patch
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
    ./autogen.sh --prefix=$out --enable-progpath=$out/bin

    cd ../backendnet
    ./autogen.sh --prefix=$out --enable-libpath=$out/lib/bjlib --enable-progpath=$out/bin

    cd ../lgmon
    # no --prefix=$out because it builds a static library that the build system looks for in lgmon/src
    ./autogen.sh

    cd ../cngpijmon/cnijnpr
    ./autogen.sh --prefix=$out --enable-libpath=$out/lib/bjlib

    cd ../..;
  '';

  preBuild = ''
    pushd lgmon
    make
    popd
  '';

  preInstall = ''
    mkdir -p $out/bin $out/lib/cups/filter $out/share/cups/model;
  '';

  postInstall = ''
    set -o xtrace
    for pr in e510  ip7200  mg2200  mg3200  mg4200  mg5400  mg6300  mp230; do
      cd ppd;
      ./autogen.sh --prefix=$out --program-suffix=$pr
      make clean;
      make;
      make install;

      cd ../cnijfilter;
      ./autogen.sh --prefix=$out --program-suffix=$pr --enable-libpath=$out/lib/cups/path/lib/bjlib --enable-binpath=$out/bin;
      make clean;
      make;
      make install;

      cd ..;
    done;

    install -c -s -m 755 com/libs_bin${arch}/libcnnet.so.* $out/lib;

    mkdir -p $out/lib/bjlib;
    for pr_id in 401 402 403 405 406 407 408; do
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
    description = "Canon InkJet printer drivers for the MP430 MG2200 E510 MG3200 MG4200 MG5400 MG6300 and IP7200 series.";
    homepage = "https://www.canon-europe.com/support/consumer_products/products/printers/inkjet/pixma_ip_series/pixma_ip7250.html?type=drivers&driverdetailid=tcm:13-994531";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ terlar ];
  };
}
