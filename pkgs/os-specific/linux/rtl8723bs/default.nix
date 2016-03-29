{ stdenv, fetchFromGitHub, kernel }:

let
  ver = "c517f2b";
in
stdenv.mkDerivation rec {
  name = "rtl8723bs-${kernel.version}-c517f2b";

  src = fetchFromGitHub {
    owner = "hadess";
    repo = "rtl8723bs";
    rev = "c517f2bf8bcc3d57311252ea7cd49ae81466eead";
    sha256 = "0phzrhq85g52pi2b74a9sr9l2x6dzlz714k3pix486w2x5axw4xb";
  };

  hardeningDisable = [ "pic" ];

  patchPhase = ''
    substituteInPlace ./Makefile --replace /lib/modules/ "${kernel.dev}/lib/modules/"
    substituteInPlace ./Makefile --replace '$(shell uname -r)' "${kernel.modDirVersion}"
    substituteInPlace ./Makefile --replace /sbin/depmod #
    substituteInPlace ./Makefile --replace '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
    substituteInPlace ./Makefile --replace '/lib/firmware' "$out/lib/firmware"
  '';

  preInstall = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
    mkdir -p "$out/lib/firmware/rtlwifi"
  '';

  meta = {
    description = "Realtek SDIO Wi-Fi driver";
    homepage = "https://github.com/hadess/rtl8723bs";
    license = stdenv.lib.licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
    broken = !stdenv.lib.versionAtLeast kernel.version "3.19";
  };
}
