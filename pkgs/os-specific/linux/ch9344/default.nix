{ stdenv, lib, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  pname = "ch9344";
  version = "0-unstable-2024-11-15";

  src = fetchFromGitHub {
    owner = "WCHSoftGroup";
    repo = "ch9344ser_linux";
    rev = "4ea8973886989d67acdd01dba213e355eacc9088";
    hash = "sha256-ZZ/8s26o7wRwHy6c0m1vZ/DtRW5od+NgiU6aXZBVfc4=";
  };

  patches = [
    ./fix-linux-6-12-build.patch
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
    maintainers = with maintainers; [ MakiseKurisu ];
  };
}
