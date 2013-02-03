{ stdenv, fetchurl, kernel, perl, autoconf, automake, libtool, coreutils, gawk }:

stdenv.mkDerivation {
  name = "spl-0.6.0-rc13-${kernel.version}";
  src = fetchurl {
    url = http://archive.zfsonlinux.org/downloads/zfsonlinux/spl/spl-0.6.0-rc13.tar.gz;
    sha256 = "1frbifj1yd7pznlhsqsiksip5amx4ljvasg8h80haaxk0yvvkr9b";
  };

  patches = [ ./install_prefix.patch ./install_prefix_2.patch ./module_prefix.patch ];

  buildInputs = [ perl kernel autoconf automake libtool ];

  NIX_CFLAGS_COMPILE = "-I${kernel}/lib/modules/${kernel.modDirVersion}/build/include/generated";

  preConfigure = ''
    ./autogen.sh

    substituteInPlace ./module/spl/spl-generic.c --replace /usr/bin/hostid   hostid
    substituteInPlace ./module/spl/spl-module.c  --replace /bin/mknod        mknod 

    substituteInPlace ./module/spl/spl-generic.c --replace "PATH=/sbin:/usr/sbin:/bin:/usr/bin" "PATH=${coreutils}:${gawk}:/bin"
    substituteInPlace ./module/spl/spl-module.c  --replace "PATH=/sbin:/usr/sbin:/bin:/usr/bin" "PATH=${coreutils}:/bin"
    substituteInPlace ./module/splat/splat-vnode.c --replace "PATH=/sbin:/usr/sbin:/bin:/usr/bin" "PATH=${coreutils}:/bin"
  '';

  configureFlags = ''
     --with-linux=${kernel}/lib/modules/${kernel.version}/build
     --with-linux-obj=${kernel}/lib/modules/${kernel.version}/build
  '';

  meta = {
    description = "Kernel module driver for solaris porting layer (needed by in-kernel zfs)";

    longDescription = ''
      This kernel module is a porting layer for ZFS to work inside the linux
      kernel. 
    '';

    homepage = http://zfsonlinux.org/;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ jcumming ];
  };
}
