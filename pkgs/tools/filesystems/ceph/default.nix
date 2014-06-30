{stdenv, fetchgit, libatomic_ops, autoconf, automake, boost, btrfsProgs, cryptopp, curl, expat,
 fcgi, fuse, gperftools, keyutils, leveldb, libaio, libedit, libtool,
 libuuid, linuxHeaders, openssl, pkgconfig, python, snappy, which, xfsprogs, xz}:

stdenv.mkDerivation rec {
  baseName="ceph";
  version="0.79";
  name="${baseName}-${version}";
  buildInputs = [
    fuse linuxHeaders pkgconfig libatomic_ops autoconf automake boost btrfsProgs cryptopp expat
    fcgi fuse gperftools keyutils leveldb libaio libedit libtool libuuid openssl pkgconfig
    python snappy which xfsprogs.lib xz
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  installFlags = "DESTDIR=\${out}";

  enableParallelBuilding = true;
  src = fetchgit {
    url = "https://github.com/ceph/ceph";
    rev = "4c2d73a5095f527c3a2168deb5fa54b3c8991a6e";
    sha256 = "0850m817wqqmw2qdnwm5jvbdgifzlc7kcd05jv526pdvmq1x92rf";
  };

  meta = {
    inherit version;
    description = "Distributed storage system";
    maintainers = [
      stdenv.lib.maintainers.ak
    ];
    platforms = with stdenv.lib.platforms; 
      linux;
  };
}
