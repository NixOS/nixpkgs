{ stdenv
, fetchFromGitHub
, pkgconfig
, autoreconfHook
, libtool
, libpcap

# Optional Dependencies
, zlib ? null
, withJansson ? true, jansson ? null
, withNflog ? true, libnetfilter_log ? null
, withSQLite ? true, sqlite ? null
, withPgSQL ? true, postgresql ? null
, withMysql ? true, libmysqlclient ? null }:

assert withJansson -> jansson != null;
assert withNflog -> libnetfilter_log != null;
assert withSQLite -> sqlite != null;
assert withPgSQL -> postgresql != null;
assert withMysql -> libmysqlclient != null;

let inherit (stdenv.lib) optional; in

stdenv.mkDerivation rec {
  version = "1.7.3";
  pname = "pmacct";

  src = fetchFromGitHub {
    owner = "pmacct";
    repo = pname;
    rev = "v${version}";
    sha256 = "0j5qmkya67q7jvaddcj00blmaac37bkir1zb3m1xmm95gm5lf2p5";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig libtool ];
  buildInputs = [ libpcap ]
    ++ optional withJansson jansson
    ++ optional withNflog libnetfilter_log
    ++ optional withSQLite sqlite
    ++ optional withPgSQL postgresql
    ++ optional withMysql [ libmysqlclient zlib ];

  configureFlags = [
    "--with-pcap-includes=${libpcap}/include"
  ] ++ optional withJansson "--enable-jansson"
    ++ optional withNflog "--enable-nflog"
    ++ optional withSQLite "--enable-sqlite3"
    ++ optional withPgSQL "--enable-pgsql"
    ++ optional withMysql "--enable-mysql";

  meta = with stdenv.lib; {
    description = "pmacct is a small set of multi-purpose passive network monitoring tools";
    longDescription = ''
      pmacct is a small set of multi-purpose passive network monitoring tools
      [NetFlow IPFIX sFlow libpcap BGP BMP RPKI IGP Streaming Telemetry]
    '';
    homepage = "http://www.pmacct.net/";
    license = licenses.gpl2;
    maintainers = [ maintainers."0x4A6F" ];
    platforms = platforms.unix;
  };
}
