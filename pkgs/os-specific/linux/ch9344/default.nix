{ stdenv, lib, fetchzip, kernel }:

stdenv.mkDerivation rec {
  pname = "ch9344";
  version = "1.9";

  src = fetchzip {
    name = "CH9344SER_LINUX.zip";
    url = "https://www.wch.cn/downloads/file/386.html#CH9344SER_LINUX.zip";
    hash = "sha256-g55ftAfjKKlUFzGhI1a/O7Eqbz6rkGf1vWuEJjBZxBE=";
  };

  patches = lib.optionals (lib.versionAtLeast kernel.modDirVersion "6.1") [
    # https://github.com/torvalds/linux/commit/a8c11c1520347be74b02312d10ef686b01b525f1
    ./fix-incompatible-pointer-types.patch
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
    homepage = "http://www.wch-ic.com/";
    downloadPage = "https://www.wch.cn/downloads/CH9344SER_LINUX_ZIP.html";
    description = "WCH CH9344/CH348 UART driver";
    longDescription = ''
      A kernel module for WinChipHead CH9344/CH348 USB To Multi Serial Ports controller.
    '';
    # Archive contains no license.
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ MakiseKurisu ];
  };
}
