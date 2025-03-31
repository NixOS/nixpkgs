{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  bc,
  nix-update-script,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rtl8821ce";
  version = "0-unstable-2025-03-12";

  src = fetchFromGitHub {
    owner = "tomaspinho";
    repo = "rtl8821ce";
    rev = "1bbfc35ece57cbdfb8473c49d3c6464eede54191";
    hash = "sha256-n9g98qORHdFVTU6jlMnCFvqW/xz6SDKqIBjT+IFEiHU=";
  };

  patches = [
    (fetchpatch {
      name = "fix-build-on-6.14.patch";
      url = "https://github.com/tomaspinho/rtl8821ce/commit/1f1809775e686a524c8eb8ebcf5957ed8e697f74.patch";
      hash = "sha256-p8lQS98i7lGMiNtmsWMKCLtwbFRJkLImUYCOLCfARTI=";
    })
  ];

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
