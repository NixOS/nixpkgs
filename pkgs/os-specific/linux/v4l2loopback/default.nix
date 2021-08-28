{ lib, stdenv, fetchFromGitHub, kernel, kmod }:

stdenv.mkDerivation rec {
  pname = "v4l2loopback";
  version = "unstable-2020-04-22-${kernel.version}";

  src = fetchFromGitHub {
    owner = "umlaeute";
    repo = "v4l2loopback";
    rev = "d26e624b4ead762d34152f9f825b3a51fb92fb9c";
    sha256 = "sha256-OA45vmuVieoL7J83D3TD5qi3SBsiqi0kiQn4i1K6dVE=";
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

  meta = with lib; {
    description = "A kernel module to create V4L2 loopback devices";
    homepage = "https://github.com/umlaeute/v4l2loopback";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fortuneteller2k ];
    platforms = platforms.linux;
  };
}
