{ stdenv, fetchFromGitHub, fetchpatch, kernel }:

stdenv.mkDerivation rec {
  name = "rtl8812au-${kernel.version}-${version}";
  version = "4.3.20";

  src = fetchFromGitHub {
    owner = "Grawp";
    repo = "rtl8812au_rtl8821au";
    rev = "d716b38abf5ca7da72d2be0adfcebe98cceeda8f";
    sha256 = "01z5p2vps3an69bbzca7ig14llc5rd6067pgs47kkhfjbsbws4ry";
  };

  patches = [
    (fetchpatch { # From PR # 42
      name = "rtl8812au-4.11.x-fix.patch";
      url = https://github.com/Grawp/rtl8812au_rtl8821au/commit/3224e74ad9c230b74a658e80dad66ab95c9e2ef5.patch;
      sha256 = "12g4yvivg4d0qm5cgxs7k54p3y7h1dc2jw6rp1xbppwf3j1z6xks";
    })
    (fetchpatch { # From PR #46
      name = "rtl8812au-4.11.9-fix.patch";
      url = https://github.com/Grawp/rtl8812au_rtl8821au/commit/58fc45a4511b8b9d6b52813168e3eee657517b1f.patch;
      sha256 = "18bag2mif5112lap2xvx2bb0wxrd13f9y9cwqv1qzp5nyqiniziz";
    })
    (fetchpatch { # From PR #43
      name = "rtl8812au-4.12-fix.patch";
      url = https://github.com/Grawp/rtl8812au_rtl8821au/commit/a5475c9f1f54099ca35c8680f2dedee11fa9edec.patch;
      sha256 = "01xa51whq1xa0sh3y2bhm65f0cryzmv46v530axqjrpnd924432d";
    })
  ];

  hardeningDisable = [ "pic" ];

  NIX_CFLAGS_COMPILE="-Wno-error=incompatible-pointer-types";

  prePatch = ''
    substituteInPlace ./Makefile --replace /lib/modules/ "${kernel.dev}/lib/modules/"
    substituteInPlace ./Makefile --replace '$(shell uname -r)' "${kernel.modDirVersion}"
    substituteInPlace ./Makefile --replace /sbin/depmod \#
    substituteInPlace ./Makefile --replace '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  preInstall = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  meta = {
    description = "Driver for Realtek 802.11ac, rtl8812au, provides the 8812au mod";
    homepage = https://github.com/Grawp/rtl8812au_rtl8821au;
    license = stdenv.lib.licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
