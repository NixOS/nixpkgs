{ stdenv, fetchFromGitHub, nukeReferences, kernel }:
with stdenv.lib;
stdenv.mkDerivation rec {
  name = "rtl8723bs-${kernel.version}-${version}";
  version = "2017-04-06";

  src = fetchFromGitHub {
    owner = "hadess";
    repo = "rtl8723bs";
    rev = "db2c4f61d48fe3b47c167c8bcd722ce83c24aca5";
    sha256 = "0pxqya14a61vv2v5ky1ldybc0mjfin9mpvmajlmv0lls904rph7g";
  };

  hardeningDisable = [ "pic" ];

  buildInputs = [ nukeReferences ];

  makeFlags = concatStringsSep " " [
    "ARCH=${stdenv.hostPlatform.platform.kernelArch}" # Normally not needed, but the Makefile sets ARCH in a broken way.
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
    homepage = https://github.com/hadess/rtl8723bs;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    broken = (! versionOlder kernel.version "4.12"); # Now in kernel staging drivers
    maintainers = with maintainers; [ elitak ];
  };
}
