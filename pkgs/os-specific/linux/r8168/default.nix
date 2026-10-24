{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}-${kernel.version}";
  pname = "r8168";
  # on update please verify that the source matches the realtek version
  version = "8.057.00";

  # This is a mirror. The original website[1] doesn't allow non-interactive
  # downloads, instead emailing you a download link.
  # [1] https://www.realtek.com/Download/List?cate_id=584
  # I've verified manually (`diff -r`) that the source code for version 8.055.00
  # is the same as the one available on the realtek website.
  src = fetchFromGitHub {
    owner = "mtorromeo";
    repo = "r8168";
    rev = version;
    sha256 = "sha256-KymQThzYKpcgCjKX3ZQ2RAWNga2d0EaWXVQmHzw8hmA=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    # avoid using the Makefile directly -- it doesn't understand
    # any kernel but the current.
    # based on the ArchLinux pkgbuild: https://git.archlinux.org/svntogit/community.git/tree/trunk/PKGBUILD?h=packages/r8168
    "-C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "modules"

    "INSTALL_MOD_PATH=${placeholder "out"}"
    "INSTALL_MOD_DIR=kernel/drivers/net/wireless/realtek/r8168"
    "INSTALL_MOD_STRIP=1"
    "DEPMOD=true"
  ];
  preBuild = ''
    absSrc=$(realpath src)
    makeFlagsArray+=("M=$absSrc")
    makeFlagsArray+=("EXTRA_CFLAGS=-DCONFIG_R8168_NAPI -DCONFIG_R8168_VLAN -DCONFIG_ASPM -DENABLE_S5WOL -DENABLE_EEE")
  '';

  enableParallelBuilding = true;

  installTargets = [ "modules_install" ];

  meta = {
    description = "Realtek r8168 driver";
    longDescription = ''
      A kernel module for Realtek 8168 network cards.
      If you want to use this driver, you might need to blacklist the r8169 driver
      by adding "r8169" to boot.blacklistedKernelModules.
    '';
    homepage = "https://github.com/mtorromeo/r8168";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
