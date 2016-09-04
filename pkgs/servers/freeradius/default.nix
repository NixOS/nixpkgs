{ stdenv, fetchurl, autoreconfHook, talloc, finger_bsd, perl
, openssl
, linkOpenssl? true
, openldap
, withLdap ? false
, sqlite
, withSqlite ? false
, libpcap
, withPcap ? true
, libcap
, withCap ? true
, libmemcached
, withMemcached ? false
, hiredis
, withRedis ? false
, libmysql
, withMysql ? false
, withJson ? false
, libyubikey
, withYubikey ? false
, collectd
, withCollectd ? false
}:

assert withSqlite -> sqlite != null;
assert withLdap -> openldap != null;
assert withPcap -> libpcap != null;
assert withCap -> libcap != null;
assert withMemcached -> libmemcached != null;
assert withRedis -> hiredis != null;
assert withMysql -> libmysql != null;
assert withYubikey -> libyubikey != null;
assert withCollectd -> collectd != null;

## TODO: include windbind optionally (via samba?)
## TODO: include oracle optionally
## TODO: include ykclient optionally

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "freeradius-${version}";
  version = "3.0.11";

  buildInputs = [ autoreconfHook openssl talloc finger_bsd perl ]
    ++ optional withLdap [ openldap ]
    ++ optional withSqlite [ sqlite ]
    ++ optional withPcap [ libpcap ]
    ++ optional withCap [ libcap ]
    ++ optional withMemcached [ libmemcached ]
    ++ optional withRedis [ hiredis ]
    ++ optional withMysql [ libmysql ]
    ++ optional withJson [ pkgs."json-c" ]
    ++ optional withYubikey [ libyubikey ]
    ++ optional withCollectd [ collectd ];

  # NOTE: are the --with-{lib}-lib-dir and --with-{lib}-include-dir necessary with buildInputs ?

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

  src = fetchurl {
    url = "ftp://ftp.freeradius.org/pub/freeradius/freeradius-server-${version}.tar.gz";
    sha256 = "0naxw9b060rbp4409904j6nr2zwl6wbjrbq1839xrwhmaf8p4yxr";
  };

  meta = with stdenv.lib; {
    homepage = http://freeradius.org/;
    description = "A modular, high performance free RADIUS suite";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with maintainers; [ sheenobu ];
    platforms = with platforms; linux;
  };

}

