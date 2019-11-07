{ stdenv, fetchFromGitHub, libpcap,/* gnutls, libgcrypt,*/ libxml2, glib
, geoip, geolite-legacy, sqlite, which, autoreconfHook, mariadb, readline80
, pkgconfig, groff, curl, json_c, zeromq, rrdtool, libmaxminddb
}:

# ntopng includes LuaJIT, mongoose, rrdtool and zeromq in its third-party/
# directory, but we use zeromq, and rrdtool from nixpkgs

let
  ndpi = fetchFromGitHub {
    owner = "ntop";
    repo = "nDPI";
    rev = "2.6";
    sha256 = "1rivxbia4cqn8n3lp9ijrhj4ppclnici0ixnara9bh97sf5gpk9z";
  };
in stdenv.mkDerivation rec {
  version = "3.8";
  pname = "ntopng";

  src = fetchFromGitHub {
    owner = "ntop";
    repo = "ntopng";
    rev = version;
    sha256 = "170cqggrja4am34cwwb4h92hyb38jpsb81rqwncqd0lydqx114f0";
  };

  postUnpack = ''
    cp    --recursive ${ndpi} $sourceRoot/nDPI
    chmod --recursive +w $sourceRoot/nDPI
  '';

  patches = [
    ./0001-Undo-weird-modification-of-data_dir.patch
    ./0002-fix-cookie-match-issue.patch
  ];

  buildInputs = [ libpcap/* gnutls libgcrypt*/ libxml2 libmaxminddb glib geoip geolite-legacy
    sqlite curl json_c zeromq mariadb readline80 rrdtool ];

  nativeBuildInputs = [ autoreconfHook groff pkgconfig which ];

  autoreconfPhase = ''
    $shell autogen.sh
  '';

  preConfigure = ''
    substituteInPlace Makefile.in --replace "/bin/rm" "rm"
  '';

  preBuild = ''
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
