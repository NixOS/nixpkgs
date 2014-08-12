{ stdenv, fetchurl, kernel, perl, autoconf, automake, libtool, coreutils, gawk }:

stdenv.mkDerivation {
  name = "spl-0.6.3-${kernel.version}";
  src = fetchurl {
    url = http://archive.zfsonlinux.org/downloads/zfsonlinux/spl/spl-0.6.3.tar.gz;
    sha256 = "1qqzyj2if5wai4jiwml4i8s6v8k7hbi7jmiph800lhkk5j8s72l9";
  };

  patches = [ ./install_prefix.patch ./const.patch ];

  buildInputs = [ perl autoconf automake libtool ];

  preConfigure = ''
    ./autogen.sh

    substituteInPlace ./module/spl/spl-generic.c --replace /usr/bin/hostid hostid
    substituteInPlace ./module/spl/spl-module.c  --replace /bin/mknod mknod

    substituteInPlace ./module/spl/spl-generic.c --replace "PATH=/sbin:/usr/sbin:/bin:/usr/bin" "PATH=${coreutils}:${gawk}:/bin"
    substituteInPlace ./module/splat/splat-vnode.c --replace "PATH=/sbin:/usr/sbin:/bin:/usr/bin" "PATH=${coreutils}:/bin"
    substituteInPlace ./module/splat/splat-linux.c --replace "PATH=/sbin:/usr/sbin:/bin:/usr/bin" "PATH=${coreutils}:/bin"
  '';

  configureFlags = ''
     --with-linux=${kernel.dev}/lib/modules/${kernel.modDirVersion}/source
     --with-linux-obj=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Kernel module driver for solaris porting layer (needed by in-kernel zfs)";

    longDescription = ''
      This kernel module is a porting layer for ZFS to work inside the linux
      kernel.
    '';

    homepage = http://zfsonlinux.org/;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ jcumming wizeman ];
  };
}
