{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "rtl8126";
  version = "${kernel.version}-${finalAttrs.src.tag}";

  src = fetchFromGitHub {
    owner = "openwrt";
    repo = "rtl8126";
    tag = "10.016.00";
    hash = "sha256-Smf512av6B8b5dAwOLVRelBf6goLdLqSJ0bLCf+f2b8=";
  };

  makeFlags = kernelModuleMakeFlags ++ [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "-C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(PWD)"
  ];

  buildFlags = [
    "ENABLE_FIBER_SUPPORT=y"
    "ENABLE_PTP_SUPPORT=y"
    "ENABLE_RSS_SUPPORT=y"
    "ENABLE_USE_FIRMWARE_FILE=y"
  ];
  buildTargets = [ "modules" ];

  installFlags = [ "INSTALL_MOD_PATH=$(out)" ];
  installTargets = [ "modules_install" ];

  enableParallelBuilding = true;

  meta = {
    description = "Realtek RTL8126 5GbE PCIe driver";
    homepage = "https://github.com/openwrt/rtl8126";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.azahi ];
  };
})
