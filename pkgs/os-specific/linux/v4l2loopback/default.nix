{ stdenv, fetchurl, kernel, kmod }:

stdenv.mkDerivation rec {
  name = "v4l2loopback-${version}-${kernel.version}";
  version = "0.8.0";

  src = fetchurl {
    url = "https://github.com/umlaeute/v4l2loopback/archive/v${version}.tar.gz";
    sha256 = "1rhsgc4prrj8s6njixic7fs5m3gs94v9hhf3am6lnfh5yv6yab9h";
  };
  
  preBuild = ''
    substituteInPlace Makefile --replace "modules_install" "INSTALL_MOD_PATH=$out modules_install"
    sed -i '/depmod/d' Makefile
    export PATH=${kmod}/sbin:$PATH
  '';

  patches = [ ./kernel-3.18-fix.patch ];
  
  buildInputs = [ kmod ];
  
  makeFlags = [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  meta = with stdenv.lib; {
    description = "A kernel module to create V4L2 loopback devices";
    homepage = https://github.com/umlaeute/v4l2loopback;
    license = licenses.gpl2;
    maintainers = [ maintainers.iElectric ];
    platforms = platforms.linux;
  };
}
