{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
}:

stdenv.mkDerivation rec {
  pname = "ch9344";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "WCHSoftGroup";
    repo = "ch9344ser_linux";
    rev = "e0a38c4f4f9d4c1f5e2e3a352b7b1010b33aa322";
    hash = "sha256-ldYoGmG9DAjASl3xL8djeZ8jRHlcBQdAt0KYAr53epI=";
  };

  patches = [
    ./fix-linux-6-12-build.patch
    ./fix-linux-6-15-build.patch
    ./fix-linux-6-16-build.patch
  ];

  sourceRoot = "${src.name}/driver";
  hardeningDisable = [ "pic" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  preBuild = ''
    substituteInPlace Makefile --replace "KERNELDIR :=" "KERNELDIR ?="
  '';

  makeFlags = [
    "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    runHook preInstall
    install -D ch9344.ko $out/lib/modules/${kernel.modDirVersion}/usb/serial/ch9344.ko
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.wch-ic.com/";
    downloadPage = "https://github.com/WCHSoftGroup/ch9344ser_linux";
    description = "WCH CH9344/CH348 UART driver";
    longDescription = ''
      A kernel module for WinChipHead CH9344/CH348 USB To Multi Serial Ports controller.
    '';
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ RadxaYuntian ];
  };
}
