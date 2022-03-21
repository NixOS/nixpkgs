{ lib
, stdenv
, fetchurl
, fetchpatch
, autoreconfHook
, bsd-finger
, perl
, talloc
, linkOpenssl? true, openssl
, withCap ? true, libcap
, withCollectd ? false, collectd
, withJson ? false, json_c
, withLdap ? true, openldap
, withMemcached ? false, libmemcached
, withMysql ? false, libmysqlclient
, withPcap ? true, libpcap
, withRedis ? false, hiredis
, withRest ? false, curl
, withSqlite ? true, sqlite
, withYubikey ? false, libyubikey
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

stdenv.mkDerivation rec {
  pname = "freeradius";
  version = "3.0.25";

  src = fetchurl {
    url = "ftp://ftp.freeradius.org/pub/freeradius/freeradius-server-${version}.tar.gz";
    hash = "sha256-SIOmi7PO5GAlNZqXwWkc5lXour/W3DwCHQDhCaL/TBA=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ openssl talloc bsd-finger perl ]
    ++ lib.optional withCap libcap
    ++ lib.optional withCollectd collectd
    ++ lib.optional withJson json_c
    ++ lib.optional withLdap openldap
    ++ lib.optional withMemcached libmemcached
    ++ lib.optional withMysql libmysqlclient
    ++ lib.optional withPcap libpcap
    ++ lib.optional withRedis hiredis
    ++ lib.optional withRest curl
    ++ lib.optional withSqlite sqlite
    ++ lib.optional withYubikey libyubikey;

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ] ++ lib.optional (!linkOpenssl) "--with-openssl=no";

  postPatch = ''
    substituteInPlace src/main/checkrad.in \
      --replace "/usr/bin/finger" "${bsd-finger}/bin/finger"
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
## TODO: include windbind optionally (via samba?)
## TODO: include oracle optionally
## TODO: include ykclient optionally
