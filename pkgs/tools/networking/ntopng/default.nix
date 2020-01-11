{ stdenv, fetchurl, libpcap,/* gnutls, libgcrypt,*/ libxml2, glib
, geoip, geolite-legacy, sqlite, which, autoreconfHook, git
, pkgconfig, groff, curl, json_c, luajit, zeromq, rrdtool
}:

# ntopng includes LuaJIT, mongoose, rrdtool and zeromq in its third-party/
# directory, but we use luajit, zeromq, and rrdtool from nixpkgs

stdenv.mkDerivation rec {
  name = "ntopng-2.0";

  src = fetchurl {
    urls = [
      "mirror://sourceforge/project/ntop/ntopng/old/${name}.tar.gz"
      "mirror://sourceforge/project/ntop/ntopng/${name}.tar.gz"
    ];
    sha256 = "0l82ivh05cmmqcvs26r6y69z849d28njipphqzvnakf43ggddgrw";
  };

  patches = [
    ./0001-Undo-weird-modification-of-data_dir.patch
    ./0002-Remove-requirement-to-have-writeable-callback-dir.patch
    ./0003-New-libpcap-defines-SOCKET.patch
  ];

  buildInputs = [ libpcap/* gnutls libgcrypt*/ libxml2 glib geoip geolite-legacy
    sqlite which autoreconfHook git pkgconfig groff curl json_c luajit zeromq
    rrdtool ];


  autoreconfPhase = ''
    substituteInPlace autogen.sh --replace "/bin/rm" "rm"
    substituteInPlace nDPI/autogen.sh --replace "/bin/rm" "rm"
    $shell autogen.sh
  '';

  preConfigure = ''
    substituteInPlace Makefile.in --replace "/bin/rm" "rm"
  '';

  preBuild = ''
    substituteInPlace src/Ntop.cpp --replace "/usr/local" "$out"

    sed -e "s|\(#define CONST_DEFAULT_DATA_DIR\).*|\1 \"/var/lib/ntopng\"|g" \
        -e "s|\(#define CONST_DEFAULT_DOCS_DIR\).*|\1 \"$out/share/ntopng/httpdocs\"|g" \
        -e "s|\(#define CONST_DEFAULT_SCRIPTS_DIR\).*|\1 \"$out/share/ntopng/scripts\"|g" \
        -e "s|\(#define CONST_DEFAULT_CALLBACKS_DIR\).*|\1 \"$out/share/ntopng/scripts/callbacks\"|g" \
        -e "s|\(#define CONST_DEFAULT_INSTALL_DIR\).*|\1 \"$out/share/ntopng\"|g" \
        -i include/ntop_defines.h

    rm -rf httpdocs/geoip
    ln -s ${geolite-legacy}/share/GeoIP httpdocs/geoip
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    sed 's|LIBS += -lstdc++.6||' -i Makefile
  '';

  NIX_CFLAGS_COMPILE = "-fpermissive"
    + stdenv.lib.optionalString stdenv.cc.isClang " -Wno-error=reserved-user-defined-literal";

  meta = with stdenv.lib; {
    description = "High-speed web-based traffic analysis and flow collection tool";
    homepage = http://www.ntop.org/products/ntop/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.bjornfor ];
  };
}
