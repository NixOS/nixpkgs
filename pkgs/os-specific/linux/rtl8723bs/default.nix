{ stdenv, fetchFromGitHub, nukeReferences, kernel }:
with stdenv.lib;
stdenv.mkDerivation rec {
  name = "rtl8723bs-${kernel.version}-${version}";
  version = "2016-04-11";

  src = fetchFromGitHub {
    owner = "hadess";
    repo = "rtl8723bs";
    rev = "11ab92d8ccd71c80f0102828366b14ef6b676fb2";
    sha256 = "05q7mf12xcb00v6ba4wwvqi53q7ph5brfkj17xf6vkx4jr7xxnmm";
  };

  hardeningDisable = [ "pic" ];

  buildInputs = [ nukeReferences ];

  makeFlags = concatStringsSep " " [
    "ARCH=${stdenv.platform.kernelArch}" # Normally not needed, but the Makefile sets ARCH in a broken way.
    "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" # Makefile uses $(uname -r); breaks us.
  ];

  enableParallelBuilding = true;

  # The Makefile doesn't use env-vars well, so install manually:
  installPhase = ''
    mkdir -p      $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless
    cp r8723bs.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless

    nuke-refs $(find $out -name "*.ko")
  '';

  meta = {
    description = "Realtek SDIO Wi-Fi driver";
    homepage = "https://github.com/hadess/rtl8723bs";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    broken = (! versionAtLeast kernel.version "3.19")
      || (kernel.features.grsecurity or false);
    maintainers = with maintainers; [ elitak ];
  };
}
