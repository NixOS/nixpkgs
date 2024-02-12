{ lib, stdenv, fetchFromGitHub, kernel, bc }:

stdenv.mkDerivation {
  pname = "rtl8188eus-aircrack";
  version = "${kernel.version}-unstable-2023-09-21";

  src = fetchFromGitHub {
    owner = "aircrack-ng";
    repo = "rtl8188eus";
    rev = "3fae7237ba121f1169e9a2ea55040dc123697d3b";
    sha256 = "sha256-ILSMEt9nMdg1ZbFeatWm8Yxf6a/E7Vm7KtKhN933KTc=";
  };

  prePatch = ''
    substituteInPlace ./Makefile \
      --replace /lib/modules/ "${kernel.dev}/lib/modules/" \
      --replace /sbin/depmod \# \
      --replace '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  hardeningDisable = [ "pic" ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ bc ] ++ kernel.moduleBuildDependencies;

  preInstall = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  meta = with lib; {
    description = "RealTek RTL8188eus WiFi driver with monitor mode & frame injection support";
    homepage = "https://github.com/aircrack-ng/rtl8188eus";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ moni ];
    broken = (lib.versionAtLeast kernel.version "6.6") || ((lib.versions.majorMinor kernel.version) == "5.4" && kernel.isHardened);
  };
}
