{ stdenv, fetchgit, pkgconfig, nettools, gettext, readline, openssl, python
, ncurses ? null
, sqlite ? null, postgresql ? null, mysql ? null, libcap ? null
, zlib ? null, lzo ? null, acl ? null, ceph ? null
}:

assert sqlite != null || postgresql != null || mysql != null;

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "bareos-${version}";
  version = "14.2.1";

  src = fetchgit {
    url = "git://github.com/bareos/bareos";
    rev = "refs/tags/Release/${version}";
    sha256 = "0m7v1szi45m71zjhj3inn5hh9f4529slhiihm88rfw8006aqb6ly";
  };

  buildInputs = [
    pkgconfig nettools gettext readline openssl python
    ncurses sqlite postgresql mysql libcap zlib lzo acl ceph
  ];

  configureFlags = [
    "--exec-prefix=\${out}"
    "--with-openssl=${openssl}"
    "--with-python=${python}"
    "--with-readline=${readline}"
    "--enable-ndmp"
    "--enable-lmdb"
  ] ++ optional (sqlite != null) "--with-sqlite3=${sqlite}"
    ++ optional (postgresql != null) "--with-postgresql=${postgresql}"
    ++ optional (mysql != null) "--with-mysql=${mysql}";

  meta = with stdenv.lib; {
    homepage = http://www.bareos.org/;
    description = "a fork of the bacula project.";
    license = licenses.agpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
