{
  stdenv,
  lib,
  fetchzip,
  autoconf,
  automake,
  cups,
  glib,
  libxml2,
  libusb1,
  libtool,
  withDebug ? false,
}:

stdenv.mkDerivation {
  pname = "cnijfilter2";

  version = "6.40";

  src = fetchzip {
    url = "https://gdlp01.c-wss.com/gds/1/0100011381/01/cnijfilter2-source-6.40-1.tar.gz";
    sha256 = "3RoG83jLOsdTEmvUkkxb7wa8oBrJA4v1mGtxTGwSowU=";
  };

  nativeBuildInputs = [
    automake
    autoconf
  ];
  buildInputs = [
    cups
    glib
    libxml2
    libusb1
    libtool
  ];

  patches = [
    ./patches/get_protocol.patch
  ];

  # lgmon3's --enable-libdir flag is used soley for specifying in which
  # directory the cnnnet.ini cache file should reside.
  # NixOS uses /var/cache/cups, and given the name, it seems like a reasonable
  # place to put the cnnet.ini file, and thus we do so.
  #
  # Note that the drivers attempt to dlopen
  # $out/lib/cups/filter/libcnbpcnclapicom2.so
  buildPhase =
    ''
      mkdir -p $out/lib
      cp com/libs_bin_x86_64/* $out/lib
      mkdir -p $out/lib/cups/filter
      ln -s $out/lib/libcnbpcnclapicom2.so $out/lib/cups/filter

      export NIX_LDFLAGS="$NIX_LDFLAGS -L$out/lib"
    ''
    + lib.optionalString withDebug ''
      export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -D__DEBUG__ -DDEBUG_LOG"
    ''
    + ''

      (
        cd lgmon3
        substituteInPlace src/Makefile.am \
          --replace /usr/include/libusb-1.0 \
                    ${libusb1.dev}/include/libusb-1.0
        ./autogen.sh --prefix=$out --enable-progpath=$out/bin \
                     --datadir=$out/share \
                     --enable-libdir=/var/cache/cups
        make
      )

      (
        cd cmdtocanonij2
        ./autogen.sh --prefix=$out
        make
      )

      (
        cd cmdtocanonij3
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
      cd cmdtocanonij3
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
    description = "Canon InkJet printer drivers for many Pixma series printers.";
    longDescription = ''
      Canon InjKet printer drivers for series E200, E300, E3100, E3300, E4200, E450, E470, E480,
      G3000, G3010, G4000, G4010, G5000, G5080, G6000, G6050, G6080, G7000, G7050, G7080, GM2000,
      GM2080, GM4000, GM4080, iB4000, iB4100, iP110, MB2000, MB2100, MB2300, MB2700, MB5000,
      MB5100, MB5300, MB5400, MG2900, MG3000, MG3600, MG5600, MG5700, MG6600, MG6700, MG6800,
      MG6900, MG7500, MG7700, MX490, TR4500, TR703, TR7500, TR7530, TR8500, TR8530, TR8580, TR9530,
      TS200, TS300, TS3100, TS3300, TS5000, TS5100, TS5300, TS5380, TS6000, TS6100, TS6130, TS6180,
      TS6200, TS6230, TS6280, TS6300, TS6330, TS6380, TS700, TS708, TS7330, TS8000, TS8100, TS8130,
      TS8180, TS8200, TS8230, TS8280, TS8300, TS8330, TS8380, TS9000, TS9100, TS9180, TS9500,
      TS9580, XK50, XK60, XK70, XK80.
    '';
    homepage = "https://hk.canon/en/support/0101048401/1";
    license = licenses.unfree;
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
    maintainers = with maintainers; [ ];
  };
}
