{
  stdenv,
  lib,
  fetchgit,
  kernel,
  kernelModuleMakeFlags,
  kmod,
}:
let
  version = "22.03.5";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "trelay";
  version = "${version}-${kernel.version}";

  src = fetchgit {
    url = "https://git.openwrt.org/openwrt/openwrt.git";
    rev = "v${version}";
    hash = "sha256-5f9LvaZUxtfTpTR268QMkEmHUpn/nct+MVa44SBGT5c=";
    sparseCheckout = [ "package/kernel/trelay/src" ];
  };

  sourceRoot = "${finalAttrs.src.name}/package/kernel/trelay/src";
  hardeningDisable = [
    "pic"
    "format"
  ];
  nativeBuildInputs = [ kmod ] ++ kernel.moduleBuildDependencies;

  postPatch = ''
    cp '${./Makefile}' Makefile
  '';

  makeFlags = kernelModuleMakeFlags ++ [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];

  meta = with lib; {
    description = "For relaying IP packets between two devices to build a IP bridge between them";
    longDescription = ''
      A kernel module that relays ethernet packets between two devices (similar to a bridge),
      but without any MAC address checks.

      This makes it possible to bridge client mode or ad-hoc mode wifi devices to ethernet VLANs,
      assuming the remote end uses the same source MAC address as the device that packets are
      supposed to exit from.
    '';
    homepage = "https://github.com/openwrt/openwrt/tree/main/package/kernel/trelay";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.aprl ];
    platforms = platforms.linux;
    broken = lib.versionOlder kernel.version "5.10";
  };
})
