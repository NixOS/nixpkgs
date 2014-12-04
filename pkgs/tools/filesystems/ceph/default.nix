{ stdenv, fetchgit, autoconf, automake, makeWrapper, pkgconfig, libtool, which
, boost, btrfsProgs, cryptopp, curl, expat, fcgi, fuse, gperftools, keyutils
, leveldb, libaio, libatomic_ops, libedit, libuuid, linuxHeaders, openssl
, python, snappy, udev, xfsprogs, xz
, zfs ? null
}:

with stdenv.lib;
let
  wrapArgs = "--prefix PYTHONPATH : \"$(toPythonPath $out)\""
    + " --prefix PYTHONPATH : \"$(toPythonPath ${python.modules.readline})\""
    + " --prefix PATH : \"$out/bin\""
    + " --prefix LD_LIBRARY_PATH : \"$out/lib\"";
in
stdenv.mkDerivation rec {
  name="ceph-${version}";
  version="0.89";

  src = fetchgit {
    url = "git://github.com/ceph/ceph.git";
    rev = "refs/tags/v${version}";
    sha256 = "1ky1j8qb2nz3qzlhdcb6ppdjx7wb3icq7n0l5mm9x3q2ijbwvhlz";
  };

  patches = [
    ./0001-Makefile-env-Don-t-force-sbin.patch
  ];

  nativeBuildInputs = [ autoconf automake makeWrapper pkgconfig libtool which ];
  buildInputs = [
    boost btrfsProgs cryptopp curl expat fcgi fuse gperftools keyutils
    libatomic_ops leveldb libaio libedit libuuid linuxHeaders openssl python
    snappy udev xfsprogs.lib xz zfs
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags = [
    "--exec_prefix=$(out)"
  ] ++ optional (zfs != null) "--with-zfs=${zfs}";

  postInstall = ''
    wrapProgram $out/bin/ceph ${wrapArgs}
    wrapProgram $out/bin/ceph-brag ${wrapArgs}
    wrapProgram $out/bin/ceph-rest-api ${wrapArgs}
    wrapProgram $out/sbin/ceph-create-keys ${wrapArgs}
    wrapProgram $out/sbin/ceph-disk ${wrapArgs}
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = http://ceph.com/;
    description = "Distributed storage system";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ ak wkennington ];
    platforms = with platforms; linux;
  };
}
