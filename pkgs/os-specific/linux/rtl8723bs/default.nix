{ stdenv, fetchFromGitHub, nukeReferences, kernel }:
with stdenv.lib;
stdenv.mkDerivation rec {
  name = "rtl8723bs-${kernel.version}-${rev}";
  rev = "b0ef98fff09bc091da3fb4157f3118427ecd6dea";

  src = fetchFromGitHub {
    owner = "hadess";
    repo = "rtl8723bs";
    inherit rev;
    sha256 = "0la1r7vh2klirh1lqq8spyq8wpq3qk25pn2zpr4czdh2lml366x0";
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
    broken = ! versionAtLeast kernel.version "3.19";
    maintainers = with maintainers; [ elitak ];
  };
}
