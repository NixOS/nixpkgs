{ stdenv, fetchFromGitHub, pkgconfig, nettools, gettext, libtool
, readline ? null, openssl ? null, python ? null, ncurses ? null
, sqlite ? null, postgresql ? null, libmysql ? null, zlib ? null, lzo ? null
, acl ? null, glusterfs ? null, libceph ? null, libcap ? null
}:

assert sqlite != null || postgresql != null || libmysql != null;

with stdenv.lib;
let
  withGlusterfs = "\${with_glusterfs_directory}";
in
stdenv.mkDerivation rec {
  name = "bareos-${version}";
  version = "14.2.4";

  src = fetchFromGitHub {
    owner = "bareos";
    repo = "bareos";
    rev = "Release/${version}";
    name = "${name}-src";
    sha256 = "0shb91pawdgrn6rb4np3zyyxv36899nvwf8jaihkg0wvb01viqzr";
  };

  buildInputs = [
    pkgconfig nettools gettext readline openssl python
    ncurses sqlite postgresql libmysql zlib lzo acl glusterfs libceph libcap
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
  ] ++ optionals (readline != null) [ "--disable-conio" "--enable-readline" "--with-readline=${readline}" ]
    ++ optional (python != null) "--with-python=${python}"
    ++ optional (openssl != null) "--with-openssl=${openssl}"
    ++ optional (sqlite != null) "--with-sqlite3=${sqlite}"
    ++ optional (postgresql != null) "--with-postgresql=${postgresql}"
    ++ optional (libmysql != null) "--with-mysql=${libmysql}"
    ++ optional (zlib != null) "--with-zlib=${zlib}"
    ++ optional (lzo != null) "--with-lzo=${lzo}"
    ++ optional (acl != null) "--enable-acl"
    ++ optional (glusterfs != null) "--with-glusterfs=${glusterfs}"
    ++ optional (libceph != null) "--with-cephfs=${libceph}";

  installFlags = [
    "sysconfdir=\${out}/etc"
    "working_dir=\${TMPDIR}"
    "log_dir=\${TMPDIR}"
  ];

  meta = with stdenv.lib; {
    homepage = http://www.bareos.org/;
    description = "a fork of the bacula project.";
    license = licenses.agpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
