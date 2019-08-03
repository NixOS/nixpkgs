{ stdenv, fetchurl, autoreconfHook, talloc, finger_bsd, perl
, openssl
, linkOpenssl? true
, openldap
, withLdap ? true
, sqlite
, withSqlite ? true
, libpcap
, withPcap ? true
, libcap
, withCap ? true
, libmemcached
, withMemcached ? false
, hiredis
, withRedis ? false
, mysql
, withMysql ? false
, json_c
, withJson ? false
, libyubikey
, withYubikey ? false
, collectd
, withCollectd ? false
, curl
, withRest ? false
}:

assert withSqlite -> sqlite != null;
assert withLdap -> openldap != null;
assert withPcap -> libpcap != null;
assert withCap -> libcap != null;
assert withMemcached -> libmemcached != null;
assert withRedis -> hiredis != null;
assert withMysql -> mysql != null;
assert withYubikey -> libyubikey != null;
assert withCollectd -> collectd != null;
assert withRest -> curl != null && withJson;

## TODO: include windbind optionally (via samba?)
## TODO: include oracle optionally
## TODO: include ykclient optionally

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "freeradius-${version}";
  version = "3.0.19";

  src = fetchurl {
    url = "ftp://ftp.freeradius.org/pub/freeradius/freeradius-server-${version}.tar.gz";
    sha256 = "0v5b46rq878093ff549ijccy98md1l7l4rvshjxs672il0zvq5i4";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ openssl talloc finger_bsd perl ]
    ++ optional withLdap openldap
    ++ optional withSqlite sqlite
    ++ optional withPcap libpcap
    ++ optional withCap libcap
    ++ optional withMemcached libmemcached
    ++ optional withRedis hiredis
    ++ optional withMysql mysql.connector-c
    ++ optional withJson json_c
    ++ optional withYubikey libyubikey
    ++ optional withCollectd collectd
    ++ optional withRest curl;


  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ] ++ optional (!linkOpenssl) "--with-openssl=no";

  postPatch = ''
    substituteInPlace src/main/checkrad.in --replace "/usr/bin/finger" "${finger_bsd}/bin/finger"
  '';

  installFlags = [
    "sysconfdir=\${out}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  outputs = [ "out" "dev" "man" "doc" ];

  meta = with stdenv.lib; {
    homepage = https://freeradius.org/;
    description = "A modular, high performance free RADIUS suite";
    license = licenses.gpl2;
    maintainers = with maintainers; [ sheenobu willibutz ];
    platforms = with platforms; linux;
  };

}

