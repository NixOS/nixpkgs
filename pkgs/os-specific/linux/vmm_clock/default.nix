{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch2,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation rec {
  pname = "vmm_clock";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "voutilad";
    repo = "vmm_clock";
    rev = version;
    hash = "sha256-XYRxrVixvImxr2j3qxBcv1df1LvPRKqKKgegW3HqUcQ=";
  };

  patches = lib.optionals (lib.versionAtLeast kernel.version "6.16") [
    (fetchpatch2 {
      url = "https://raw.githubusercontent.com/alpinelinux/aports/d5c16d40fc1e874bb88a32bbe4deeae55cb49657/community/vmm_clock-lts/kernel-7.3.patch";
      hash = "sha256-A/wBdMKt4Bw9nGF7emcw3IETHRc0FIC0HTvxPDmten4=";
    })
  ];

  hardeningDisable = [
    "pic"
    "format"
  ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  extraConfig = ''
    CONFIG_RTC_HCTOSYS yes
  '';

  makeFlags = kernelModuleMakeFlags ++ [
    "INSTALL_MOD_PATH=$(out)"
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  meta = {
    description = "Experimental implementation of a kvmclock-derived clocksource for Linux guests under OpenBSD's hypervisor";
    homepage = "https://github.com/voutilad/vmm_clock";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ qbit ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };

  enableParallelBuilding = true;
}
