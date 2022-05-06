{ lib, stdenv, fetchFromGitHub, kernel, kmod }:

stdenv.mkDerivation rec {
  pname = "v4l2loopback";
  version = "unstable-2021-07-13-${kernel.version}";

  src = fetchFromGitHub {
    owner = "umlaeute";
    repo = "v4l2loopback";
    rev = "baf9de279afc7a7c7513e9c40a0c9ff88f456af4";
    sha256 = "sha256-uglYTeqz81fgkKYYU9Cw8x9+S088jGxDEGkb3rmkhrw==";
  };

  hardeningDisable = [ "format" "pic" ];

  preBuild = ''
    substituteInPlace Makefile --replace "modules_install" "INSTALL_MOD_PATH=$out modules_install"
    sed -i '/depmod/d' Makefile
  '';

  nativeBuildInputs = [ kmod ] ++ kernel.moduleBuildDependencies;

  postInstall = ''
    make install-utils PREFIX=$bin
  '';

  outputs = [ "out" "bin" ];

  makeFlags = kernel.makeFlags ++ [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  meta = with lib; {
    description = "A kernel module to create V4L2 loopback devices";
    homepage = "https://github.com/umlaeute/v4l2loopback";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fortuneteller2k ];
    platforms = platforms.linux;
    outputsToInstall = [ "out" ];
  };
}
