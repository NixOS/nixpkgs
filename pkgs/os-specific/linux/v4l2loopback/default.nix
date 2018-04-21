{ stdenv, fetchFromGitHub, kernel, kmod }:

stdenv.mkDerivation rec {
  name = "v4l2loopback-${version}-${kernel.version}";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "umlaeute";
    repo = "v4l2loopback";
    rev = "v${version}";
    sha256 = "1wb5qmy13w8rl4279bwp69s4sb1x5hk5d2n563p1yk8yi567p2az";
  };

  hardeningDisable = [ "format" "pic" ];

  preBuild = ''
    substituteInPlace Makefile --replace "modules_install" "INSTALL_MOD_PATH=$out modules_install"
    sed -i '/depmod/d' Makefile
    export PATH=${kmod}/sbin:$PATH
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;
  buildInputs = [ kmod ];

  makeFlags = [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  meta = with stdenv.lib; {
    description = "A kernel module to create V4L2 loopback devices";
    homepage = https://github.com/umlaeute/v4l2loopback;
    license = licenses.gpl2;
    maintainers = [ maintainers.domenkozar ];
    platforms = platforms.linux;
  };
}
