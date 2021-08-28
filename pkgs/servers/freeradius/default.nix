{ lib, stdenv, fetchurl, fetchpatch, autoreconfHook, talloc, finger_bsd, perl
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
, libmysqlclient
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
assert withMysql -> libmysqlclient != null;
assert withYubikey -> libyubikey != null;
assert withCollectd -> collectd != null;
assert withRest -> curl != null && withJson;

## TODO: include windbind optionally (via samba?)
## TODO: include oracle optionally
## TODO: include ykclient optionally

with lib;
stdenv.mkDerivation rec {
  pname = "freeradius";
  version = "3.0.21";

  src = fetchurl {
    url = "ftp://ftp.freeradius.org/pub/freeradius/freeradius-server-${version}.tar.gz";
    sha256 = "1bij07angf6ll6bq8lccd4fx1a1clf7k13kh5vbryh6lf7a19y9b";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ openssl talloc finger_bsd perl ]
    ++ optional withLdap openldap
    ++ optional withSqlite sqlite
    ++ optional withPcap libpcap
    ++ optional withCap libcap
    ++ optional withMemcached libmemcached
    ++ optional withRedis hiredis
    ++ optional withMysql libmysqlclient
    ++ optional withJson json_c
    ++ optional withYubikey libyubikey
    ++ optional withCollectd collectd
    ++ optional withRest curl;


  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ] ++ optional (!linkOpenssl) "--with-openssl=no";

  patches = lib.optional withRest (fetchpatch {
    # Fix HTTP/2 in rest
    url = "https://github.com/FreeRADIUS/freeradius-server/commit/6286520698a3cc4053b4d49eb0a61d9ba77632aa.patch";
    sha256 = "1ycvr3ql1mfkvzydnn4aiygnidicv2hgllppv37nb1p2pk02159g";
  });

  postPatch = ''
    substituteInPlace src/main/checkrad.in --replace "/usr/bin/finger" "${finger_bsd}/bin/finger"
  '';

  # By default, freeradius will generate Diffie-Hellman parameters and
  # self-signed TLS certificates during installation. We don't want
  # this, for several reasons:
  # - reproducibility (random generation)
  # - we don't want _anybody_ to use a cert where the private key is on our public binary cache!
  # - we don't want the certs to change each time the package is rebuilt
  # So let's avoid anything getting into our output.
  makeFlags = [ "LOCAL_CERT_FILES=" ];

  installFlags = [
    "sysconfdir=\${out}/etc"
    "localstatedir=\${TMPDIR}"
    "INSTALL_CERT_FILES=" # see comment at makeFlags
  ];

  outputs = [ "out" "dev" "man" "doc" ];

  meta = with lib; {
    homepage = "https://freeradius.org/";
    description = "A modular, high performance free RADIUS suite";
    license = licenses.gpl2;
    maintainers = with maintainers; [ sheenobu willibutz fpletz lheckemann elseym ];
    platforms = with platforms; linux;
  };

}

