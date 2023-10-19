{ lib, stdenv, fetchFromGitHub, cmake, pkg-config
, krb5, xfsprogs, jemalloc, dbus, libcap
, ntirpc, liburcu, bison, flex, nfs-utils, acl
} :

stdenv.mkDerivation rec {
  pname = "nfs-ganesha";
  version = "5.5.3";

  src = fetchFromGitHub {
    owner = "nfs-ganesha";
    repo = "nfs-ganesha";
    rev = "V${version}";
    sha256 = "sha256-bHywbdlUSuwk05FVYK5PR+RGlNisV+syGrs9dtanNg8=";
  };

  preConfigure = "cd src";

  cmakeFlags = [
    "-DUSE_SYSTEM_NTIRPC=ON"
    "-DSYSSTATEDIR=/var"
    "-DENABLE_VFS_POSIX_ACL=ON"
    "-DUSE_ACL_MAPPING=ON"
    "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON"
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

  postFixup = ''
    patchelf --add-rpath $out/lib $out/bin/ganesha.nfsd
  '';

  meta = with lib; {
    description = "NFS server that runs in user space";
    homepage = "https://github.com/nfs-ganesha/nfs-ganesha/wiki";
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux;
    license = licenses.lgpl3Plus;
  };
}
