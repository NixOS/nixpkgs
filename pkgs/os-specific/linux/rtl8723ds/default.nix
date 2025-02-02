{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  bc,
}:

stdenv.mkDerivation {
  pname = "rtl8723ds";
  version = "${kernel.version}-unstable-2023-11-14";

  src = fetchFromGitHub {
    owner = "lwfinger";
    repo = "rtl8723ds";
    rev = "52e593e8c889b68ba58bd51cbdbcad7fe71362e4";
    sha256 = "sha256-SszvDuWN9opkXyVQAOLjnNtPp93qrKgnGvzK0y7Y9b0=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = [ bc ] ++ kernel.moduleBuildDependencies;

  makeFlags =
    [
      "ARCH=${stdenv.hostPlatform.linuxArch}"
    ]
    ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
      "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
    ];

  postPatch = ''
    substituteInPlace ./Makefile \
      --replace /lib/modules/ "${kernel.dev}/lib/modules/" \
      --replace "/sbin/depmod" "#" \
      --replace '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  preInstall = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Linux driver for RTL8723DS";
    homepage = "https://github.com/lwfinger/rtl8723ds";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ chuangzhu ];
  };
}
