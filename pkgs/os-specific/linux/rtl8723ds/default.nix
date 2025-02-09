{ lib, stdenv, fetchFromGitHub, kernel, bc }:

stdenv.mkDerivation {
  pname = "rtl8723ds";
  version = "${kernel.version}-unstable-2022-12-01";

  src = fetchFromGitHub {
    owner = "lwfinger";
    repo = "rtl8723ds";
    rev = "a638cc8639015b8b9390af3350fab0366b6c87e7";
    sha256 = "sha256-qfVE7k71NPzw3FwoOaUxH66PnDjbpMAF6CyOyUVdSMA=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = [ bc ] ++ kernel.moduleBuildDependencies;

  makeFlags = [
    "ARCH=${stdenv.hostPlatform.linuxArch}"
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
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
    description = "Linux driver for RTL8723DS.";
    homepage = "https://github.com/lwfinger/rtl8723ds";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ chuangzhu ];
  };
}
