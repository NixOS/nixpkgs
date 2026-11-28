{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kmod,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ixgbe";
  version = "6.4.5";
  name = "ixgbe-${finalAttrs.version}-${kernel.version}";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "ethernet-linux-ixgbe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZAPA4kdH4hDGHgMC5ohDpRylWqgUh4pWUUumVbWmUNg=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies ++ [ which ];
  hardeningDisable = [ "pic" ];

  configurePhase = ''
    runHook preConfigure
    cd src
    # common.mk uses src for its writable module directory, not the fetched source.
    unset src
    makeFlagsArray+=(
      KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/source
      KOBJ=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build
      INSTALL_MOD_PATH=$out
      MANDIR=/share/man
    )
    substituteInPlace common.mk \
      --replace-fail /sbin/depmod ${kmod}/bin/depmod \
      --replace-fail /boot/System.map /not-exists
    runHook postConfigure
  '';

  enableParallelBuilding = true;
  # Leave depmod and initramfs updates to NixOS.
  installTargets = [
    "modules_install"
    "mandocs_install"
  ];

  # NixOS generates indexes for the combined module tree, not each package.
  postInstall = ''
    rm -f $out/lib/modules/${kernel.modDirVersion}/modules.*
  '';

  meta = {
    description = "Intel 10 Gigabit PCI Express network driver";
    homepage = "https://github.com/intel/ethernet-linux-ixgbe";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    # ixgbe_devlink_minsrev_validate has an incompatible callback signature.
    broken = lib.versionAtLeast kernel.version "7.3";
  };
})
