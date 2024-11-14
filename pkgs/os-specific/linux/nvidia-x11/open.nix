{ stdenv
, lib
, fetchFromGitHub
, kernel
, nvidia_x11
, hash
, patches ? [ ]
, broken ? false
}:

stdenv.mkDerivation ({
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

  makeFlags = kernel.makeFlags ++ [
    "SYSSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/source"
    "SYSOUT=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "MODLIB=$(out)/lib/modules/${kernel.modDirVersion}"
    {
      aarch64-linux = "TARGET_ARCH=aarch64";
      x86_64-linux = "TARGET_ARCH=x86_64";
    }.${stdenv.hostPlatform.system}
  ];

  installTargets = [ "modules_install" ];
  enableParallelBuilding = true;

  meta = with lib; {
    description = "NVIDIA Linux Open GPU Kernel Module";
    homepage = "https://github.com/NVIDIA/open-gpu-kernel-modules";
    license = with licenses; [ gpl2Plus mit ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ nickcao ];
    inherit broken;
  };
} // lib.optionalAttrs stdenv.hostPlatform.isAarch64 {
  env.NIX_CFLAGS_COMPILE = "-fno-stack-protector";
})
