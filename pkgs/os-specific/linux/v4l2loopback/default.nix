{ lib, stdenv, fetchFromGitHub, kernel, kmod }:

stdenv.mkDerivation rec {
  pname = "v4l2loopback";
  version = "unstable-2023-02-19-${kernel.version}";

  src = fetchFromGitHub {
    owner = "umlaeute";
    repo = "v4l2loopback";
    rev = "fb410fc7af40e972058809a191fae9517b9313af";
    hash = "sha256-gLFtR7s+3LUQ0BZxHbmaArHbufuphbtAX99nxJU3c84=";
  };

  patches = [
    # fix bug https://github.com/umlaeute/v4l2loopback/issues/535
    ./revert-pr518.patch
  ];

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
    maintainers = with maintainers; [ moni ];
    platforms = platforms.linux;
    outputsToInstall = [ "out" ];
  };
}
