{ stdenv, lib, fetchzip,
  autoconf, automake, libtool,
  cups, popt, libtiff, libpng,
  ghostscript }:

/* this derivation is basically just a transcription of the rpm .spec
   file included in the tarball */

stdenv.mkDerivation rec {
  name = "cnijfilter-${version}";

  /* important note about versions: cnijfilter packages seem to use
     versions in a non-standard way.  the version indicates which
     printers are supported in the package.  so this package should
     not be "upgraded" in the usual way.

     instead, if you want to include another version supporting your
     printer, you should try to abstract out the common things (which
     should be pretty much everything except the version and the 'pr'
     and 'pr_id' values to loop over). */
  version = "2.80";

  src = fetchzip {
    url = "http://gdlp01.c-wss.com/gds/1/0100000841/01/cnijfilter-common-2.80-1.tar.gz";
    sha256 = "06s9nl155yxmx56056y22kz1p5b2sb5fhr3gf4ddlczjkd1xch53";
  };

  buildInputs = [ autoconf libtool automake
                  cups popt libtiff libpng
                  ghostscript ];

  patches = [ ./patches/missing-include.patch
              ./patches/libpng15.patch ];

  postPatch = ''
    sed -i "s|/usr/lib/cups/backend|$out/lib/cups/backend|" backend/src/Makefile.am;
    sed -i "s|/usr|$out|" backend/src/cnij_backend_common.c;
    sed -i "s|/usr/bin|${ghostscript}/bin|" pstocanonij/filter/pstocanonij.c;
    sed -i "s|/usr/local|$out|" libs/bjexec/bjexec.c;
  '';

  configurePhase = ''
    cd libs
    ./autogen.sh --prefix=$out;

    cd ../cngpij
    ./autogen.sh --prefix=$out --enable-progpath=$out/bin;

    cd ../pstocanonij
    ./autogen.sh --prefix=$out --enable-progpath=$out/bin;

    cd ../backend
    ./autogen.sh --prefix=$out;
    cd ..;
  '';

  preInstall = ''
    mkdir -p $out/bin $out/lib/cups/filter $out/share/cups/model;
  '';

  postInstall = ''
    for pr in mp140 mp210 ip3500 mp520 ip4500 mp610; do
      cd ppd;
      ./autogen.sh --prefix=$out --program-suffix=$pr
      make clean;
      make;
      make install;

      cd ../cnijfilter;
      ./autogen.sh --prefix=$out --program-suffix=$pr --enable-libpath=/var/lib/cups/path/lib/bjlib --enable-binpath=$out/bin;
      make clean;
      make;
      make install;

      cd ..;
    done;

    mkdir -p $out/lib/bjlib;
    for pr_id in 315 316 319 328 326 327; do
      install -c -m 755 $pr_id/database/* $out/lib/bjlib;
      install -c -s -m 755 $pr_id/libs_bin/*.so.* $out/lib;
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
    description = "Canon InkJet printer drivers for the iP5400, MP520, MP210, MP140, iP3500, and MP610 series.  (MP520 drivers also work for MX700.)";
    homepage = "http://support-asia.canon-asia.com/content/EN/0100084101.html";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jerith666 ];
  };
}
