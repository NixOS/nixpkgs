{ lib, stdenv, fetchFromGitHub, cmake, pkg-config
, krb5, xfsprogs, jemalloc, dbus, libcap
, ntirpc, liburcu, bison, flex, nfs-utils, acl
} :

stdenv.mkDerivation rec {
  pname = "nfs-ganesha";
  version = "5.4";

  src = fetchFromGitHub {
    owner = "nfs-ganesha";
    repo = "nfs-ganesha";
    rev = "V${version}";
    sha256 = "sha256-zKIFjplZtxOEPIH9PUw1gGPS4VSdgv2Zj1oOp3If9W0=";
  };

  preConfigure = "cd src";

  cmakeFlags = [
    "-DUSE_SYSTEM_NTIRPC=ON"
    "-DSYSSTATEDIR=/var"
    "-DENABLE_VFS_POSIX_ACL=ON"
    "-DUSE_ACL_MAPPING=ON"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    bison
    flex
  ];

  buildInputs = [
    acl
    krb5
    xfsprogs
    jemalloc
    dbus.lib
    libcap
    ntirpc
    liburcu
    nfs-utils
  ];

  meta = with lib; {
    description = "NFS server that runs in user space";
    homepage = "https://github.com/nfs-ganesha/nfs-ganesha/wiki";
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux;
    license = licenses.lgpl3Plus;
  };
}
