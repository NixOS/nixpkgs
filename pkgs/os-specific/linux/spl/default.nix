{ fetchFromGitHub, stdenv, autoconf, automake, libtool, coreutils, gawk
, configFile ? "all"

# Kernel dependencies
, kernel ? null
}:

with stdenv.lib;
let
  buildKernel = any (n: n == configFile) [ "kernel" "all" ];
  buildUser = any (n: n == configFile) [ "user" "all" ];
in

assert any (n: n == configFile) [ "kernel" "user" "all" ];
assert buildKernel -> kernel != null;

stdenv.mkDerivation rec {
  name = "spl-${configFile}-${version}${optionalString buildKernel "-${kernel.version}"}";

  version = "0.6.5.5";

  src = fetchFromGitHub {
    owner = "zfsonlinux";
    repo = "spl";
    rev = "spl-${version}";
    sha256 = "1f49qv648klg2sn1v1wzwd6ls1njjj0hrazz7msd74ayhwm0zcw7";
  };

  patches = [ ./const.patch ./install_prefix.patch ];

  buildInputs = [ autoconf automake libtool ];

  hardeningDisable = [ "pic" ];

  preConfigure = ''
    ./autogen.sh

    substituteInPlace ./module/spl/spl-generic.c --replace /usr/bin/hostid hostid
    substituteInPlace ./module/spl/spl-module.c  --replace /bin/mknod mknod

    substituteInPlace ./module/spl/spl-generic.c --replace "PATH=/sbin:/usr/sbin:/bin:/usr/bin" "PATH=${coreutils}:${gawk}:/bin"
    substituteInPlace ./module/splat/splat-vnode.c --replace "PATH=/sbin:/usr/sbin:/bin:/usr/bin" "PATH=${coreutils}:/bin"
    substituteInPlace ./module/splat/splat-linux.c --replace "PATH=/sbin:/usr/sbin:/bin:/usr/bin" "PATH=${coreutils}:/bin"
  '';

  configureFlags = [
    "--with-config=${configFile}"
  ] ++ optionals buildKernel [
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
    maintainers = with maintainers; [ jcumming wizeman wkennington ];
    broken = (kernel.features.grsecurity or false);
  };
}
