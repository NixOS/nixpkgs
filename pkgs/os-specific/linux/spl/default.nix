{ stdenv, fetchurl, kernel, perl, autoconf, automake, libtool, coreutils, gawk }:

stdenv.mkDerivation {
  name = "spl-0.6.0-rc11";
  src = fetchurl {
    url = http://github.com/downloads/zfsonlinux/spl/spl-0.6.0-rc11.tar.gz;
    sha256 = "0brsrr9hvzlpx7a26nn8rw9k2kh9s75hmxp6h087hi64hzxysf8g";
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
      This kernel module is a porting layer for ZFS to work inside the linux kernel. 

      LICENSE NOTE: the Linux kernel is licensed under the GNU General Public
      License which is incompatible with ZFS which is licensed under the Sun CDDL.
      While both the GPL and CDDL are open source licenses their terms are such that
      it is impossible to simultaneously satisfy both licenses. This means that a
      single derived work of the Linux kernel and ZFS cannot be legally distributed.

      The ZFS code can be modified to build as a CDDL licensed kernel module
      which is not distributed as part of the Linux kernel. This makes a Native ZFS
      on Linux implementation possible if you are willing to download and build it
      yourself.
    '';

    homepage = http://zfsonlinux.org/;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.cddl;
    maintainers = with stdenv.lib.maintainers; [ jcumming ];
  };
}
