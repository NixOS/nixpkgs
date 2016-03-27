{ stdenv, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  name = "rtl8812au-${kernel.version}-${version}";
  version = "4.2.2-1";
  
  src = fetchFromGitHub {
    owner = "csssuf";
    repo = "rtl8812au";
    rev = "874906aec694c800bfc29b146737b88dae767832";
    sha256 = "14ifhplawipfd6971mxw76dv3ygwc0n8sbz2l3f0vvkin6x88bsj";
  };
  
  patchPhase = ''
    substituteInPlace ./Makefile --replace /lib/modules/ "${kernel.dev}/lib/modules/"
    substituteInPlace ./Makefile --replace '$(shell uname -r)' "${kernel.modDirVersion}"
    substituteInPlace ./Makefile --replace /sbin/depmod #
    substituteInPlace ./Makefile --replace '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';
  
  preInstall = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';
   
  meta = {
    description = "Driver for Realtek 802.11ac, rtl8812au, provides the 8812au mod";
    homepage = "https://github.com/csssuf/rtl8812au";
    license = stdenv.lib.licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
    broken = (kernel.features.grsecurity or false);
  };
}
