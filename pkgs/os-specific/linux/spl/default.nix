{ fetchFromGitHub, stdenv, autoreconfHook, coreutils, gawk
, fetchpatch
# Kernel dependencies
, kernel
}:

with stdenv.lib;

assert kernel != null;

stdenv.mkDerivation rec {
  name = "spl-${version}-${kernel.version}";
  version = "0.7.13";

  src = fetchFromGitHub {
    owner = "zfsonlinux";
    repo = "spl";
    rev = "spl-${version}";
    sha256 = "1rzqgiszy8ad2gx20577azp1y5jgad0907slfzl5y2zb05jgaipa";
  };

  patches = [ ./install_prefix.patch ];

  # Backported fix for 0.7.13 to build with 5.1, please remove when updating to 0.7.14
  postPatch = optionalString (versionAtLeast kernel.version "5.1") ''
    sed -i 's/get_ds()/KERNEL_DS/g' module/spl/spl-vnode.c
  '';

  nativeBuildInputs = [ autoreconfHook ] ++ kernel.moduleBuildDependencies;

  hardeningDisable = [ "fortify" "stackprotector" "pic" ];

  preConfigure = ''
    substituteInPlace ./module/spl/spl-generic.c --replace /usr/bin/hostid hostid
    substituteInPlace ./module/spl/spl-generic.c --replace "PATH=/sbin:/usr/sbin:/bin:/usr/bin" "PATH=${coreutils}:${gawk}:/bin"
    substituteInPlace ./module/splat/splat-vnode.c --replace "PATH=/sbin:/usr/sbin:/bin:/usr/bin" "PATH=${coreutils}:/bin"
    substituteInPlace ./module/splat/splat-linux.c --replace "PATH=/sbin:/usr/sbin:/bin:/usr/bin" "PATH=${coreutils}:/bin"
  '';

  configureFlags = [
    "--with-config=kernel"
    "--with-linux=${kernel.dev}/lib/modules/${kernel.modDirVersion}/source"
    "--with-linux-obj=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Kernel module driver for solaris porting layer (needed by in-kernel zfs)";

    longDescription = ''
      This kernel module is a porting layer for ZFS to work inside the linux
      kernel.
    '';

    homepage = http://zfsonlinux.org/;
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ jcumming wizeman fpletz globin ];
  };
}
