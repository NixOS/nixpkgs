{ stdenv, fetchFromGitHub, pkgconfig, nettools, gettext, readline, openssl, python
, ncurses ? null
, sqlite ? null, postgresql ? null, mysql ? null, libcap ? null
, zlib ? null, lzo ? null, acl ? null, ceph ? null
}:

assert sqlite != null || postgresql != null || mysql != null;

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "bareos-${version}";
  version = "14.2.2";

  src = fetchFromGitHub {
    owner = "bareos";
    repo = "bareos";
    rev = "Release/${version}";
    name = "${name}-src";
    sha256 = "12605jibvj6kdp15s8jpzb9fw1mfm53npf8ib2jfn1r4hvhdrl4j";
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
