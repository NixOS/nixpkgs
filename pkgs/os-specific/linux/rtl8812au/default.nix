{ stdenv, fetchFromGitHub, kernel, bc }:

stdenv.mkDerivation rec {
  name = "rtl8812au-${kernel.version}-${version}";
  version = "5.2.20_25672.20171213";

  src = fetchFromGitHub {
    owner = "zebulon2";
    repo = "rtl8812au-driver-5.2.20";
    rev = "aca1e0677bfe56c6c4914358df007c97486e7095";
    sha256 = "19av8fkh3mvs2f57iibrg0cfyhjnnx4cbnfzv5aj7v5gb0j3dp0p";
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
