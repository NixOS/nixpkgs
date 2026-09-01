{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  bc,
}:

stdenv.mkDerivation {
  pname = "rtl8188eus-aircrack";
  version = "${kernel.version}-unstable-2026-06-22";

  src = fetchFromGitHub {
    owner = "gglluukk";
    repo = "rtl8188eus";
    rev = "cbeae98cb423378dfd5e5efb63290fe43a6ed965";
    hash = "sha256-wiWG0ndtQML/h88alNyQOX64krpJOf56HyB8LW5dYbA=";
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
