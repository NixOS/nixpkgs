{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  nvidia_x11,
  hash,
  patches ? [ ],
  broken ? false,
}:

stdenv.mkDerivation (
  {
    pname = "nvidia-open";
    version = "${kernel.version}-${nvidia_x11.version}";

    src = fetchFromGitHub {
      owner = "NVIDIA";
      repo = "open-gpu-kernel-modules";
      rev = nvidia_x11.version;
      inherit hash;
    };

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

    installTargets = [ "modules_install" ];
    enableParallelBuilding = true;

    meta = with lib; {
      description = "NVIDIA Linux Open GPU Kernel Module";
      homepage = "https://github.com/NVIDIA/open-gpu-kernel-modules";
      license = with licenses; [
        gpl2Plus
        mit
      ];
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      maintainers = with maintainers; [ nickcao ];
      inherit broken;
    };
  }
  // lib.optionalAttrs stdenv.hostPlatform.isAarch64 {
    env.NIX_CFLAGS_COMPILE = "-fno-stack-protector";
  }
)
