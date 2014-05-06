{ fetchgit, stdenv, kernel, cmake, perl }:

stdenv.mkDerivation rec {
  name = "sysdig-${version}-${kernel.version}";
  version = "0.1.81";

  src = fetchgit {
    url = "https://github.com/draios/sysdig";
    rev = "refs/tags/${version}";
    sha256 = "1n7jgm6x9nvcwqf6y69bqh7fq24i1p1hsr0sy4gngf6flc70p9dl";
  };

  preConfigure = ''
    export KERNELDIR="${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    export INSTALL_MOD_PATH="$out"
  '';

  postInstall = ''
    make install_driver
  '';

  buildInputs = [ kernel cmake perl ];

  meta = {
    description = "System-level exploration: capture system state and activity from a running Linux instance, then save, filter and analyze";
    homepage = http://www.sysdig.org/;
    license = "GPLv2";
    maintainers = [ ];
    platforms = stdenv.lib.platforms.linux;
  };
}

