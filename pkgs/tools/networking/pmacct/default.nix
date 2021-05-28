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

let inherit (stdenv.lib) getDev optional optionalString; in

stdenv.mkDerivation rec {
  version = "1.7.5";
  pname = "pmacct";

  src = fetchFromGitHub {
    owner = "pmacct";
    repo = pname;
    rev = "v${version}";
    sha256 = "17p5isrq5w58hvmzhc6akbd37ins3c95g0rvhhdm0v33khzxmran";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig libtool ];
  buildInputs = [ libpcap ]
    ++ optional withJansson jansson
    ++ optional withNflog libnetfilter_log
    ++ optional withSQLite sqlite
    ++ optional withPgSQL postgresql
    ++ optional withMysql [ libmysqlclient zlib ];

  MYSQL_CONFIG =
    optionalString withMysql "${getDev libmysqlclient}/bin/mysql_config";

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
    maintainers = with maintainers; [ _0x4A6F ];
    platforms = platforms.unix;
  };
}
