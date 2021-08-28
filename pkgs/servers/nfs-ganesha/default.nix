{ lib, stdenv, fetchFromGitHub, cmake, pkg-config
, krb5, xfsprogs, jemalloc, dbus, libcap
, ntirpc, liburcu, bison, flex, nfs-utils
} :

stdenv.mkDerivation rec {
  pname = "nfs-ganesha";
  version = "3.5";

  src = fetchFromGitHub {
    owner = "nfs-ganesha";
    repo = "nfs-ganesha";
    rev = "V${version}";
    sha256 = "sha256-N0qVlnMshsEcWEpPhtR+zXwFKXlik1XnEuZdFMjpZTE=";
  };

  patches = [ ./sysstatedir.patch ];

  preConfigure = "cd src";

  cmakeFlags = [ "-DUSE_SYSTEM_NTIRPC=ON" ];

  nativeBuildInputs = [
    cmake
    pkg-config
    bison
    flex
  ];

  buildInputs = [
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
