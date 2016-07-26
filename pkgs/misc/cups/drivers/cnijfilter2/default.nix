{ stdenv, lib, fetchzip, autoconf, automake, cups, glib, libxml2, libusb
, withDebug ? false }:

stdenv.mkDerivation rec {
  name = "cnijfilter2-${version}";

  version = "5.30";

  src = fetchzip {
    url = "http://gdlp01.c-wss.com/gds/9/0100007129/01/cnijfilter2-source-5.30-1.tar.gz";
    sha256 = "0gnl9arwmkblljsczspcgggx85a19vcmhmbjfyv1bq236yqixv5c";
  };

  buildInputs = [
    cups automake autoconf glib libxml2 libusb
  ];

  # lgmon3's --enable-libdir flag is used soley for specifying in which
  # directory the cnnnet.ini cache file should reside.
  # NixOS uses /var/cache/cups, and given the name, it seems like a reasonable
  # place to put the cnnet.ini file, and thus we do so.
  #
  # Note that the drivers attempt to dlopen
  # $out/lib/cups/filter/libcnbpcnclapicom2.so
  buildPhase = ''
    mkdir -p $out/lib
    cp com/libs_bin64/* $out/lib
    mkdir -p $out/lib/cups/filter
    ln -s $out/lib/libcnbpcnclapicom2.so $out/lib/cups/filter

    export NIX_LDFLAGS="$NIX_LDFLAGS -L$out/lib"
  '' + lib.optionalString withDebug ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -D__DEBUG__ -DDEBUG_LOG"
  '' + ''

    (
      cd lgmon3
      substituteInPlace src/Makefile.am \
        --replace /usr/include/libusb-1.0 \
                  ${libusb.dev}/include/libusb-1.0
      ./autogen.sh --prefix=$out --enable-progpath=$out/bin \
                   --enable-libdir=/var/cache/cups
      make
    )

    (
      cd cmdtocanonij2
      ./autogen.sh --prefix=$out
      make
    )

    (
      cd cnijbe2
      substituteInPlace src/Makefile.am \
        --replace "/usr/lib/cups/backend" \
                  "$out/lib/cups/backend"
      ./autogen.sh --prefix=$out --enable-progpath=$out/bin
      make
    )

    (
      cd rastertocanonij
      ./autogen.sh --prefix=$out --enable-progpath=$out/bin
      make
    )

    (
      cd tocanonij
      ./autogen.sh --prefix=$out --enable-progpath=$out/bin
      make
    )

    (
      cd tocnpwg
      ./autogen.sh --prefix=$out --enable-progpath=$out/bin
      make
    )
  '';

  installPhase = ''
    (
      cd lgmon3
      make install
    )

    (
      cd cmdtocanonij2
      make install
    )

    (
      cd cnijbe2
      make install
    )

    (
      cd rastertocanonij
      make install
    )

    (
      cd tocanonij
      make install
    )

    (
      cd tocnpwg
      make install
    )

    mkdir -p $out/share/cups/model
    cp ppd/*.ppd $out/share/cups/model
  '';

  meta = with lib; {
    description = "Canon InkJet printer drivers for the MG7500, MG6700, MG6600, MG5600, MG2900, MB2000, MB2300, iB4000, MB5000, MB5300, iP110, E450, MX490, E480, MG7700, MG6900, MG6800, MG5700, MG3600, and G3000 series.";
    homepage = "http://support-th.canon-asia.com/contents/TH/EN/0100712901.html";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
