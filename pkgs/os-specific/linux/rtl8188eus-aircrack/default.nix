{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  bc,
}:

stdenv.mkDerivation {
  pname = "rtl8188eus-aircrack";
  version = "${kernel.version}-unstable-2026-04-17";

  src = fetchFromGitHub {
    owner = "gglluukk";
    repo = "rtl8188eus";
    rev = "761e72a451b9ad9211636aefdd71ed266d639d3d";
    hash = "sha256-hDVP9vKsBWQkOnV1c3cK2RXCVZPgef0Usmd+zgkCnUI=";
  };

  prePatch = ''
    substituteInPlace ./Makefile \
      --replace-fail /lib/modules/ "${kernel.dev}/lib/modules/" \
      --replace-fail /sbin/depmod \# \
      --replace-fail '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  hardeningDisable = [ "pic" ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ bc ] ++ kernel.moduleBuildDependencies;

  preInstall = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  meta = {
    description = "RealTek RTL8188eus WiFi driver with monitor mode & frame injection support";
    homepage = "https://github.com/gglluukk/rtl8188eus";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ moni ];
  };
}
