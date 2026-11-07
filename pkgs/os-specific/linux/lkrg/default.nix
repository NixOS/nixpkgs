{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  kernel,
  kernelModuleMakeFlags,
}:
let
  isKernelRT =
    (kernel.structuredExtraConfig ? PREEMPT_RT)
    && (kernel.structuredExtraConfig.PREEMPT_RT == lib.kernel.yes);
in
stdenv.mkDerivation (finalAttrs: {
  name = "${finalAttrs.pname}-${finalAttrs.version}-${kernel.version}";
  pname = "lkrg";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "lkrg-org";
    repo = "lkrg";
    rev = "v${finalAttrs.version}";
    hash = "sha256-j/0iK/I+pj69Z39lZJFaCQ3WxzZL6663Kxy4Sf46tOo=";
  };

  patches = [
    # Fix build with Linux 7.2
    (fetchpatch2 {
      name = "fix-build-with-kernel-7.2.patch";
      url = "https://github.com/lkrg-org/lkrg/commit/72495a45d85ca9c1881f7b5ac34837b2948b0a22.patch?full_index=1";
      hash = "sha256-0M18Q9aCw13ZxwwJfIcbd7668WCKgENM2Ft+ZDmsw6M=";
    })
    (fetchpatch2 {
      name = "use-memcpy-instead-of-strncpy.patch";
      url = "https://github.com/lkrg-org/lkrg/commit/ae1edab2984db76969343e1c4661a3103fbe0566.patch?full_index=1";
      hash = "sha256-hD6X6o4fq51lh9G9t7K0jhV4nhfJs/Q8j494h10GRII=";
    })
  ];

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "KERNEL=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  enableParallelBuilding = true;
  dontConfigure = true;

  prePatch = ''
    substituteInPlace Makefile --replace "KERNEL := " "KERNEL ?= "
  '';

  installPhase = ''
    runHook preInstall
    install -D lkrg.ko $out/lib/modules/${kernel.modDirVersion}/extra/lkrg.ko
    runHook postInstall
  '';

  meta = {
    description = "LKRG Linux Kernel module";
    longDescription = "LKRG performs runtime integrity checking of the Linux kernel and detection of security vulnerability exploits against the kernel.";
    homepage = "https://lkrg.org/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      chivay
      FlorianFranzen
    ];
    platforms = lib.platforms.linux;
    broken = kernel.kernelOlder "5.10" || isKernelRT;
  };
})
