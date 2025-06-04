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
  version = "0-unstable-2025-05-31";

  src = fetchFromGitHub {
    owner = "tomaspinho";
    repo = "rtl8821ce";
    rev = "66c015af7738039a2045b6da755875e126d3fe73";
    hash = "sha256-JU8ge2QpoR6nJe5G93iTEP7WOU6tLb4NJ1QrkEYUXRA=";
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
    broken =
      stdenv.hostPlatform.isAarch64
      || ((lib.versions.majorMinor kernel.version) == "5.4" && kernel.isHardened);
  };
})
