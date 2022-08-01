nvidia_x11: hash:
{ stdenv
, lib
, fetchFromGitHub
, kernel
}:

stdenv.mkDerivation {
  pname = "nvidia-open";
  version = "${kernel.version}-${nvidia_x11.version}";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "open-gpu-kernel-modules";
    rev = nvidia_x11.version;
    inherit hash;
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernel.makeFlags ++ [
    "SYSSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/source"
    "SYSOUT=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "MODLIB=$(out)/lib/modules/${kernel.modDirVersion}"
  ];

  installTargets = [ "modules_install" ];
  enableParallelBuilding = true;

  meta = with lib; {
    description = "NVIDIA Linux Open GPU Kernel Module";
    homepage = "https://github.com/NVIDIA/open-gpu-kernel-modules";
    license = with licenses; [ gpl2Plus mit ];
    platforms = platforms.linux;
    broken = kernel.kernelAtLeast "5.19";
    maintainers = with maintainers; [ nickcao ];
  };
}
