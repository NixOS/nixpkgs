{ stdenv, fetchFromGitHub, pkgconfig, nettools, gettext, libtool, flex
, readline ? null, openssl ? null, python ? null, ncurses ? null, rocksdb
, sqlite ? null, postgresql ? null, libmysql ? null, zlib ? null, lzo ? null
, jansson ? null, acl ? null, glusterfs ? null, libceph ? null, libcap ? null
}:

assert sqlite != null || postgresql != null || libmysql != null;

with stdenv.lib;
let
  withGlusterfs = "\${with_glusterfs_directory}";
in
stdenv.mkDerivation rec {
  name = "bareos-${version}";
  version = "15.2.1";

  src = fetchFromGitHub {
    owner = "bareos";
    repo = "bareos";
    rev = "Release/${version}";
    name = "${name}-src";
    sha256 = "01vnqahzjj598jjk4y7qzfnq415jh227v40sgkrdl4qcpn76spxi";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    nettools gettext readline openssl python flex ncurses sqlite postgresql
    libmysql zlib lzo jansson acl glusterfs libceph libcap rocksdb
  ];

  postPatch = ''
    sed -i 's,\(-I${withGlusterfs}/include\),\1/glusterfs,' configure
  '';

  configureFlags = [
    "--sysconfdir=/etc"
    "--exec-prefix=\${out}"
    "--enable-lockmgr"
    "--enable-dynamic-storage-backends"
    "--with-basename=nixos" # For reproducible builds since it uses the hostname otherwise
    "--with-hostname=nixos" # For reproducible builds since it uses the hostname otherwise
    "--with-working-dir=/var/lib/bareos"
    "--with-bsrdir=/var/lib/bareos"
    "--with-logdir=/var/log/bareos"
    "--with-pid-dir=/var/run/bareos"
    "--with-subsys-dir=/var/run/bareos"
    "--enable-ndmp"
    "--enable-lmdb"
    "--enable-batch-insert"
    "--enable-dynamic-cats-backends"
    "--enable-sql-pooling"
    "--enable-scsi-crypto"
  ] ++ optionals (readline != null) [ "--disable-conio" "--enable-readline" "--with-readline=${readline.dev}" ]
    ++ optional (python != null) "--with-python=${python}"
    ++ optional (openssl != null) "--with-openssl=${openssl.dev}"
    ++ optional (sqlite != null) "--with-sqlite3=${sqlite.dev}"
    ++ optional (postgresql != null) "--with-postgresql=${postgresql}"
    ++ optional (libmysql != null) "--with-mysql=${libmysql.dev}"
    ++ optional (zlib != null) "--with-zlib=${zlib.dev}"
    ++ optional (lzo != null) "--with-lzo=${lzo}"
    ++ optional (jansson != null) "--with-jansson=${jansson}"
    ++ optional (acl != null) "--enable-acl"
    ++ optional (glusterfs != null) "--with-glusterfs=${glusterfs}"
    ++ optional (libceph != null) "--with-cephfs=${libceph}";

  installFlags = [
    "sysconfdir=\${out}/etc"
    "confdir=\${out}/etc/bareos"
    "scriptdir=\${out}/etc/bareos"
    "working_dir=\${TMPDIR}"
    "log_dir=\${TMPDIR}"
    "sbindir=\${out}/bin"
  ];

  meta = with stdenv.lib; {
    homepage = http://www.bareos.org/;
    description = "A fork of the bacula project";
    license = licenses.agpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
