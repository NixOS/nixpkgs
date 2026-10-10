{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hermes-kms";
  version = "0.4.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "MrOz59";
    repo = "Hermes-KMS";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CPlnM4j6UPD4B7ILn/Q445Hi+Boi9yumRqGzbyMXQVU=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  buildInputs = [
    kernel
  ];

  # Upstream's Makefile drives kbuild itself (make modules):
  #   make -C $(KDIR) M=$(PWD)/kernel/hermes-kms $(LLVM_FLAG) modules
  # KDIR must point at the target kernel's build tree and KERNELRELEASE at
  # its version (the Makefile defaults to `uname -r`, the host kernel, which
  # is wrong in the build sandbox). Its LLVM autodetection reads
  # $(KDIR)/.config, so a clang-built kernel is handled transparently.
  makeFlags = kernelModuleMakeFlags ++ [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "KERNELRELEASE=${kernel.modDirVersion}"
    "modules"
  ];

  hardeningDisable = [
    "format"
    "pic"
    "fortify"
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 kernel/hermes-kms/hermes_kms.ko \
      $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/gpu/drm/hermes_kms/hermes_kms.ko
    runHook postInstall
  '';

  meta = {
    description = "Hermes-KMS — DRM/KMS virtual display driver: streams the compositor's scanout zero-copy as a DMA-BUF (EVDI alternative, used by the Hermes game stream host)";
    homepage = "https://github.com/MrOz59/Hermes-KMS";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    # Upstream CI builds against Arch rolling and Ubuntu LTS kernels; the
    # driver uses modern DRM shmem/atomic APIs.
    broken = kernel.kernelOlder "6.6";
    maintainers = [ lib.maintainers.NCBlizzard ];
  };
})
