{ stdenv, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  name = "rtl8812au-${kernel.version}-${version}";
  version = "4.3.20";

  src = fetchFromGitHub {
    owner = "Grawp";
    repo = "rtl8812au_rtl8821au";
    rev = "9c5b2978ab079081dd1e981353be681a1cf495de";
    sha256 = "0bx1vgs2qldwwhdgklbqz2vy9x4jg7cj3d6w6cpkndkcr7h0m5vz";
  };

  hardeningDisable = [ "pic" ];

  NIX_CFLAGS_COMPILE="-Wno-error=incompatible-pointer-types";

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
    homepage = "https://github.com/Grawp/rtl8812au_rtl8821au";
    license = stdenv.lib.licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
    broken = (kernel.features.grsecurity or false);
  };
}
