{ stdenv, fetchurl, kernelDev, perl, autoconf, automake, libtool, coreutils, gawk }:

stdenv.mkDerivation {
  name = "spl-0.6.1-${kernelDev.version}";
  src = fetchurl {
    url = "http://archive.zfsonlinux.org/downloads/zfsonlinux/spl/spl-0.6.1.tar.gz";
    sha256 = "1bnianc00bkpdbcmignzqfv9yr8h6vj56wfl7lkhi9a5m5b3xakb";
  };

  patches = [ ./install_prefix.patch ];

  buildInputs = [ perl kernelDev autoconf automake libtool ];

  preConfigure = ''
    ./autogen.sh

    substituteInPlace ./module/spl/spl-generic.c --replace /usr/bin/hostid hostid
    substituteInPlace ./module/spl/spl-module.c  --replace /bin/mknod mknod 

    substituteInPlace ./module/spl/spl-generic.c --replace "PATH=/sbin:/usr/sbin:/bin:/usr/bin" "PATH=${coreutils}:${gawk}:/bin"
    substituteInPlace ./module/splat/splat-vnode.c --replace "PATH=/sbin:/usr/sbin:/bin:/usr/bin" "PATH=${coreutils}:/bin"
    substituteInPlace ./module/splat/splat-linux.c --replace "PATH=/sbin:/usr/sbin:/bin:/usr/bin" "PATH=${coreutils}:/bin"
  '';

  configureFlags = ''
     --with-linux=${kernelDev}/lib/modules/${kernelDev.modDirVersion}/build
     --with-linux-obj=${kernelDev}/lib/modules/${kernelDev.modDirVersion}/build
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
