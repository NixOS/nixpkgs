{ stdenv, fetchurl, fetchFromGitHub, libpcap,/* gnutls, libgcrypt,*/ libxml2, glib
, geoip, geolite-legacy, sqlite, which, autoreconfHook, git, mariadb, readline80
, pkgconfig, groff, curl, json_c, luajit, zeromq, rrdtool, libmaxminddb
}:

# ntopng includes LuaJIT, mongoose, rrdtool and zeromq in its third-party/
# directory, but we use luajit, zeromq, and rrdtool from nixpkgs

let
  ndpi = fetchurl {
    url = "https://github.com/ntop/nDPI/archive/2.6.tar.gz";
    sha256 = "07prvgdbs09kyq83s5n8j0mdqrc7jwl0acr0k43ihnrq824vdpzg";
  };
in stdenv.mkDerivation rec {
  version = "3.8";
  name = "ntopng-${version}";

  src = fetchFromGitHub {
    owner = "ntop";
    repo = "ntopng";
    rev = version;
    sha256 = "170cqggrja4am34cwwb4h92hyb38jpsb81rqwncqd0lydqx114f0";
  };

  patches = [
    ./0001-Undo-weird-modification-of-data_dir.patch
  ];

  buildInputs = [ libpcap/* gnutls libgcrypt*/ libxml2 libmaxminddb glib geoip geolite-legacy
    sqlite which autoreconfHook git pkgconfig groff curl json_c luajit zeromq mariadb readline80
    rrdtool ];

  autoreconfPhase = ''
    substituteInPlace autogen.sh --replace "/bin/rm" "rm"
    $shell autogen.sh
  '';

  preConfigure = ''
    substituteInPlace Makefile.in --replace "/bin/rm" "rm"
    mkdir nDPI
    tar --extract --gzip --file=${ndpi} --strip-components=1 --directory=nDPI
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

  NIX_CFLAGS_COMPILE = [ "-fpermissive" ]
    ++ stdenv.lib.optional stdenv.cc.isClang "-Wno-error=reserved-user-defined-literal";

  meta = with stdenv.lib; {
    description = "High-speed web-based traffic analysis and flow collection tool";
    homepage = http://www.ntop.org/products/ntop/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.bjornfor ];
  };
}
