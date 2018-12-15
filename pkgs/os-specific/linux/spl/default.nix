{ fetchFromGitHub, stdenv, autoreconfHook, coreutils, gawk

# Kernel dependencies
, kernel
}:

with stdenv.lib;

assert kernel != null;

stdenv.mkDerivation rec {
  name = "spl-${version}-${kernel.version}";
  version = "0.7.12";

  src = fetchFromGitHub {
    owner = "zfsonlinux";
    repo = "spl";
    rev = "spl-${version}";
    sha256 = "13zqh1g132g63zv54l3bsg5kras9mllkx9wvlnfs13chfr7vpp4p";
  };

  patches = [ ./install_prefix.patch ];

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
    maintainers = with maintainers; [ jcumming wizeman wkennington fpletz globin ];
  };
}
