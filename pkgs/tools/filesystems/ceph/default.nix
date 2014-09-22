{ stdenv, fetchgit, autoconf, automake, makeWrapper, pkgconfig, libtool, which
, boost, btrfsProgs, cryptopp, curl, expat, fcgi, fuse, gperftools, keyutils
, leveldb, libaio, libatomic_ops, libedit, libuuid, linuxHeaders, openssl
, python, snappy, udev, xfsprogs, xz
}:

let
  wrapArgs = "--prefix PYTHONPATH : \"$(toPythonPath $out)\""
    + " --prefix PATH : \"$out/bin\""
    + " --prefix LD_LIBRARY_PATH : \"$out/lib\"";
in
stdenv.mkDerivation rec {
  name="ceph-${version}";
  version="0.85";

  src = fetchgit {
    url = "git://github.com/ceph/ceph.git";
    rev = "refs/tags/v0.85";
    sha256 = "0g98cgrs3gfsc8azg3k0n61bgna2w906qm69j4qbjkb61l83ld1z";
  };

  patches = [
    ./0001-Cleanup-boost-optionals.patch # Remove in 0.86
    ./0001-Makefile-env-Don-t-force-sbin.patch
  ];

  nativeBuildInputs = [ autoconf automake makeWrapper pkgconfig libtool which ];
  buildInputs = [
    boost boost.lib btrfsProgs cryptopp curl expat fcgi fuse gperftools keyutils
    libatomic_ops leveldb libaio libedit libuuid linuxHeaders openssl python
    snappy udev xfsprogs.lib xz
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags = [ "--exec_prefix=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/ceph ${wrapArgs}
    wrapProgram $out/bin/ceph-brag ${wrapArgs}
    wrapProgram $out/bin/ceph-rest-api ${wrapArgs}
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://ceph.com/;
    description = "Distributed storage system";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ ak wkennington ];
    platforms = with platforms; linux;
  };
}
