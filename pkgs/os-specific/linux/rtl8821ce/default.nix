{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  bc,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rtl8821ce";
  version = "0-unstable-2026-07-15";

  src = fetchFromGitHub {
    owner = "tomaspinho";
    repo = "rtl8821ce";
    rev = "2c1684a8839df13b70d13f609528218eef95c28e";
    hash = "sha256-XHsOGPXiLSmYWJ+9x6GL7jUeebh5m6odUjbVC4rf2xg=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = [ bc ] ++ kernel.moduleBuildDependencies;
  makeFlags = kernelModuleMakeFlags;

  prePatch = ''
    substituteInPlace ./Makefile \
      --replace-fail /lib/modules/ "${kernel.dev}/lib/modules/" \
      --replace-fail /sbin/depmod \# \
      --replace-fail '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  preInstall = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  enableParallelBuilding = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=master" ]; };

  meta = {
    description = "Realtek rtl8821ce driver";
    homepage = "https://github.com/tomaspinho/rtl8821ce";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ defelo ];
    broken = stdenv.hostPlatform.isAarch64;
  };
})
