{
  stdenv,
  lib,
  fetchFromGitHub,
  linuxPackages,
  git,
  kernel ? linuxPackages.kernel,
}:
stdenv.mkDerivation {
  pname = "msi-ec-kmods";
  version = "0-unstable-2024-09-19";

  src = fetchFromGitHub {
    owner = "BeardOverflow";
    repo = "msi-ec";
    rev = "94c2a45c04a07096e10d7cb1240e1a201a025dc0";
    hash = "sha256-amJUoIf5Sl62BLyHLeam2fzN1s+APoWh2dH5QVfJhCs=";
  };

  dontMakeSourcesWritable = false;

  postPatch =
    let
      targets = builtins.filter (v: v != "") [
        (lib.strings.optionalString (kernel.kernelOlder "6.2") "older-kernel-patch")
        (lib.strings.optionalString (kernel.kernelAtLeast "6.11") "6.11-kernel-patch")
      ];
      commands = builtins.map (target: "make ${target}") targets;
    in
    lib.concatStringsSep "\n" ([ "cp ${./patches/Makefile} ./Makefile" ] ++ commands);

  hardeningDisable = [ "pic" ];

  makeFlags = kernel.makeFlags ++ [
    "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies ++ [ git ];

  installTargets = [ "modules_install" ];

  enableParallelBuilding = true;

  meta = {
    description = "Kernel modules for MSI Embedded controller";
    homepage = "https://github.com/BeardOverflow/msi-ec";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.m1dugh ];
    platforms = lib.platforms.linux;
    broken = kernel.kernelOlder "6.2";
  };
}
