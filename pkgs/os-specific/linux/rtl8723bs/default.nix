{ stdenv, fetchFromGitHub, nukeReferences, kernel }:
with stdenv.lib;
stdenv.mkDerivation rec {
  name = "rtl8723bs-${kernel.version}-${rev}";
  rev = "c517f2bf8bcc3d57311252ea7cd49ae81466eead";

  src = fetchFromGitHub {
    owner = "hadess";
    repo = "rtl8723bs";
    inherit rev;
    sha256 = "0phzrhq85g52pi2b74a9sr9l2x6dzlz714k3pix486w2x5axw4xb";
  };

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

    mkdir -p                "$out/lib/firmware/rtlwifi"
    cp rtl8723bs_nic.bin    "$out/lib/firmware/rtlwifi"
    cp rtl8723bs_wowlan.bin "$out/lib/firmware/rtlwifi"

    nuke-refs $(find $out -name "*.ko")
  '';

  meta = {
    description = "Realtek SDIO Wi-Fi driver";
    homepage = "https://github.com/hadess/rtl8723bs";
    license = stdenv.lib.licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" "armv7l-linux" ];
    broken = ! versionAtLeast kernel.version "3.19";
    maintainers = with maintainers; [ elitak ];
  };
}
