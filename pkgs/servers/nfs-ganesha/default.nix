{ lib, stdenv, fetchFromGitHub, cmake, pkg-config
, krb5, xfsprogs, jemalloc, dbus, libcap
, ntirpc, liburcu, bison, flex, nfs-utils, acl
} :

stdenv.mkDerivation rec {
  pname = "nfs-ganesha";
<<<<<<< HEAD
  version = "5.5.1";
=======
  version = "5.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "nfs-ganesha";
    repo = "nfs-ganesha";
    rev = "V${version}";
<<<<<<< HEAD
    sha256 = "sha256-fbulqSRHPdlpoLH391/axxtjJ7G/9lH9BdqoLKRuIuE=";
=======
    sha256 = "sha256-yB8DyEWZVcdPMIVpTl687S1WuyBqAt7hszqVrJ9Kraw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  preConfigure = "cd src";

  cmakeFlags = [
    "-DUSE_SYSTEM_NTIRPC=ON"
    "-DSYSSTATEDIR=/var"
    "-DENABLE_VFS_POSIX_ACL=ON"
    "-DUSE_ACL_MAPPING=ON"
<<<<<<< HEAD
    "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  postFixup = ''
    patchelf --add-rpath $out/lib $out/bin/ganesha.nfsd
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "NFS server that runs in user space";
    homepage = "https://github.com/nfs-ganesha/nfs-ganesha/wiki";
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux;
    license = licenses.lgpl3Plus;
  };
}
