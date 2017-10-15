{ stdenv, fetchFromGitHub, liburcu, corosync, fuse, zookeeper_mt, curl, fcgi
 , automake, autoconf, libtool, pkgconfig, groff, yasm, systemd, libqb
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
    sha256 = "0f4l44w2a8zl92agwsmrxssdw3z4lvcxi0hac4kcj8yr4rqwlm0z";
  };

  buildInputs = [
    automake
    autoconf
    libtool
    pkgconfig
    groff
    yasm
    systemd
    libqb
    liburcu
    corosync
    zookeeper_mt
  ] ++ stdenv.lib.optional withSheepFs [
    fuse
  ] ++ stdenv.lib.optional withHttp [
    curl
    fcgi
  ];

  preConfigure = "./autogen.sh";

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
