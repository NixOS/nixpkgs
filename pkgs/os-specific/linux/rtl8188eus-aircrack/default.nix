{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  bc,
}:

stdenv.mkDerivation {
  pname = "rtl8188eus-aircrack";
  version = "${kernel.version}-unstable-2024-09-18";

  src = fetchFromGitHub {
    owner = "aircrack-ng";
    repo = "rtl8188eus";
    rev = "f969c544ab6100da3d80a5709e077f920f2df698";
    sha256 = "sha256-uwO2nDDff4t0PZw3mLWmUPOHHftDgoaBaWMXQKHQunI=";
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
    broken =
      ((lib.versions.majorMinor kernel.version) == "5.4" && kernel.isHardened)
      || kernel.kernelAtLeast "6.17";
  };
}
