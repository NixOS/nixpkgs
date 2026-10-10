{
  stdenv,
  lib,
  fetchFromGithubOrNvidia,
  kernel,
  kernelModuleMakeFlags,
  nvidia_x11,
  open,
  patches,
  broken,
  hash ? null,
  kmod,
}:

assert open -> hash != null;

stdenv.mkDerivation {
  pname = "nvidia-${if open then "open" else "kernel-modules"}";
  version = "${nvidia_x11.version}-${kernel.version}";

  src =
    if open then
      fetchFromGithubOrNvidia {
        owner = "NVIDIA";
        repo = "open-gpu-kernel-modules";
        tag = nvidia_x11.version;
        nvrepo = "NVIDIA-kernel-module-source";
        nvext = "xz";
        inherit hash;
        # remove files which causes hash mismatches
        postFetch = "rm -rf $out/.github $out/CHANGELOG.md";
      }
    else
      nvidia_x11.modsrc;

  inherit patches;

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags =
    kernelModuleMakeFlags
    ++ [
      "IGNORE_PREEMPT_RT_PRESENCE=1"
      "SYSSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/source"
      "SYSOUT=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
      "MODLIB=$(out)/lib/modules/${kernel.modDirVersion}"
      "DATE="
      "TARGET_ARCH=${stdenv.hostPlatform.parsed.cpu.name}"
    ]
    ++ lib.optionals stdenv.cc.isClang [
      "C_INCLUDE_PATH=${lib.getLib stdenv.cc.cc}/lib/clang/${lib.versions.major stdenv.cc.cc.version}/include"
    ];

  buildTargets = [ "modules" ];
  installFlags = [ "INSTALL_MOD_STRIP=1" ];
  installTargets = [ "modules_install" ];
  enableParallelBuilding = true;

  # Both variants end up with MODULE_VERSION from the version of the sources
  # they were built from (version.mk for the open module, the driver's
  # NV_VERSION_STRING for the non-open one).  Reading it back catches a hash
  # that was not updated on a version bump, which would otherwise silently
  # reuse the old tree from the store.
  doInstallCheck = true;
  nativeInstallCheckInputs = [ kmod ];
  installCheckPhase = ''
    runHook preInstallCheck
    module=$(find "$out/lib/modules" \( -name nvidia.ko -o -name 'nvidia.ko.*' \) -print -quit)
    if [ -z "$module" ]; then
      echo "no nvidia.ko found under $out/lib/modules" >&2
      exit 1
    fi
    got=$(modinfo -F version "$module")
    if [ "$got" != "${nvidia_x11.version}" ]; then
      echo "nvidia.ko reports version '$got', expected '${nvidia_x11.version}'" >&2
      exit 1
    fi
    runHook postInstallCheck
  '';

  allowedReferences = [ ];

  meta = {
    description = "NVIDIA Linux ${lib.optionalString open "Open "}GPU Kernel Modules";
    homepage =
      if open then "https://github.com/NVIDIA/open-gpu-kernel-modules" else nvidia_x11.meta.homepage;
    license =
      if open then
        with lib.licenses;
        [
          gpl2Plus
          mit
        ]
      else
        nvidia_x11.meta.license;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance =
      with lib.sourceTypes;
      [
        fromSource
      ]
      ++ lib.optional (!open) binaryNativeCode;
    maintainers = with lib.maintainers; [ nickcao ];
    inherit broken;
  };
}
