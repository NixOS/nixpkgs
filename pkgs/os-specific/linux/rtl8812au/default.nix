{ stdenv, fetchFromGitHub, kernel, bc }:

stdenv.mkDerivation rec {
  name = "rtl8812au-${kernel.version}-${version}";
  version = "5.2.20.2_28373.20180619";

  src = fetchFromGitHub {
    owner = "zebulon2";
    repo = "rtl8812au-driver-5.2.20";
    rev = "2dad788f5d71d50df4f692b67a4428967ba3d42c";
    sha256 = "17pn73j2xqya0g8f86hn1jyf9x9wp52md05yrg1md58ixsbh1kz3";
  };

  nativeBuildInputs = [ bc ];
  buildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" "format" ];

  prePatch = ''
    substituteInPlace ./Makefile --replace /lib/modules/ "${kernel.dev}/lib/modules/"
    substituteInPlace ./Makefile --replace '$(shell uname -r)' "${kernel.modDirVersion}"
    substituteInPlace ./Makefile --replace /sbin/depmod \#
    substituteInPlace ./Makefile --replace '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  preInstall = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  meta = with stdenv.lib; {
    description = "Driver for Realtek 802.11ac, rtl8812au, provides the 8812au mod";
    homepage = https://github.com/zebulon2/rtl8812au-driver-5.2.20;
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ danielfullmer ];
  };
}
