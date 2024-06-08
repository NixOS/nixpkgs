{ lib, stdenv, fetchFromGitHub, cmake, pkg-config
, krb5, xfsprogs, jemalloc, dbus, libcap
, ntirpc, liburcu, bison, flex, nfs-utils, acl
} :

stdenv.mkDerivation rec {
  pname = "nfs-ganesha";
  version = "5.9";
  outputs = [ "out" "tools" ];

  src = fetchFromGitHub {
    owner = "nfs-ganesha";
    repo = "nfs-ganesha";
    rev = "V${version}";
    sha256 = "sha256-YFQcqRZenJUdTnlYM7gPnIxU47dytSHk5ALdbpSf5Ms=";
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

  postPatch = ''
    substituteInPlace src/tools/mount.9P --replace "/bin/mount" "/usr/bin/env mount"
  '';

  postFixup = ''
    patchelf --add-rpath $out/lib $out/bin/ganesha.nfsd
  '';

  postInstall = ''
    install -Dm755 $src/src/tools/mount.9P $tools/bin/mount.9P
  '';

  meta = with lib; {
    description = "NFS server that runs in user space";
    homepage = "https://github.com/nfs-ganesha/nfs-ganesha/wiki";
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux;
    license = licenses.lgpl3Plus;
    mainProgram = "ganesha.nfsd";
    outputsToInstall = [ "out" "tools" ];
  };
}
