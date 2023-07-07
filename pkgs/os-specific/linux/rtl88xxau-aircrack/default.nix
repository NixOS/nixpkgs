{ lib, stdenv, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  pname = "rtl88xxau-aircrack";
  version = "${kernel.version}-unstable-02-05-2023";

  src = fetchFromGitHub {
    owner = "aircrack-ng";
    repo = "rtl8812au";
    rev = "35308f4dd73e77fa572c48867cce737449dd8548";
    hash = "sha256-0kHrNsTKRl/xTQpDkIOYqTtcHlytXhXX8h+6guvLmLI=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  prePatch = ''
    substituteInPlace ./Makefile \
      --replace /lib/modules/ "${kernel.dev}/lib/modules/" \
      --replace /sbin/depmod \# \
      --replace '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  preInstall = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Aircrack-ng kernel module for Realtek 88XXau network cards\n(8811au, 8812au, 8814au and 8821au chipsets) with monitor mode and injection support.";
    homepage = "https://github.com/aircrack-ng/rtl8812au";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.jethro ];
    platforms = [ "x86_64-linux" "i686-linux" "aarch64-linux" ];
  };
}
