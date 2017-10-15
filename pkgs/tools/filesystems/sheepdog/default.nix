{ stdenv, fetchFromGitHub, liburcu, corosync, fuse, zookeeper, curl, fcgi
 , withSheepFs ? false
 , withHttp ? false
}:

stdenv.mkDerivation rec {
  version = "v1.0.1";
  name = "sheepdog-${version}";

  src = fetchFromGitHub {
    owner  = "sheepdog";
    repo   = "sheepdog";
    rev    = "${version}";
    sha256 = "0c4f454d6185617f67e6ebe60c6735f481ea46460c84e2132a1c47090cf8b857";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ 
    liburcu
    corosync
    zookeeper
  ] ++ stdenv.lib.optional withSheepFs [
    fuse
  ] ++ stdenv.lib.optional withHttp [
    curl
    fcgi
  ];

  configureFlags = [
    "--enable-systemd"
    "--enable-corosync"
    "--enable-zookeeper"
    "--enable-nfs"
  ] ++ stdenv.lib.optional withSheepFs [
    "--enable-sheepfs"
  ] ++ stdenv.lib.optional withHttp [
    "--enable-http"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Distributed storage system for KVM";

    longDescription =
      ''
      Sheepdog is a distributed storage system for QEMU. It provides
      highly available block level storage volumes to virtual machines.
      Sheepdog supports advanced volume management features such as snapshot,
      cloning, and thin provisioning.
      '';

    homepage = https://sheepdog.github.io/sheepdog/;
    license = https://raw.githubusercontent.com/sheepdog/sheepdog/master/COPYING;
    platforms = stdenv.lib.platforms.linux;
  };
}
