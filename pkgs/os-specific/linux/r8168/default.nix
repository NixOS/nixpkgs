{ stdenv, lib, fetchFromGitHub, kernel }:


let modDestDir = "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/realtek/r8168";

in stdenv.mkDerivation rec {
  name = "r8168-${kernel.version}-${version}";
  # on update please verify that the source matches the realtek version
  version = "8.048.03";

  # This is a mirror. The original website[1] doesn't allow non-interactive
  # downloads, instead emailing you a download link.
  # [1] https://www.realtek.com/en/component/zoo/category/network-interface-controllers-10-100-1000m-gigabit-ethernet-pci-express-software
  # I've verified manually (`diff -r`) that the source code for version 8.046.00
  # is the same as the one available on the realtek website.
  src = fetchFromGitHub {
    owner = "mtorromeo";
    repo = "r8168";
    rev = version;
    sha256 = "1l8llpcnapcaafxp7wlyny2ywh7k6q5zygwwjl9h0l6p04cghss4";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  # avoid using the Makefile directly -- it doesn't understand
  # any kernel but the current.
  # based on the ArchLinux pkgbuild: https://git.archlinux.org/svntogit/community.git/tree/trunk/PKGBUILD?h=packages/r8168
  makeFlags = kernel.makeFlags ++ [
    "-C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(PWD)/src"
    "modules"
  ];
  preBuild = ''
    makeFlagsArray+=("EXTRA_CFLAGS=-DCONFIG_R8168_NAPI -DCONFIG_R8168_VLAN -DCONFIG_ASPM -DENABLE_S5WOL -DENABLE_EEE")
  '';

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p ${modDestDir}
    find . -name '*.ko' -exec cp --parents '{}' ${modDestDir} \;
    find ${modDestDir} -name '*.ko' -exec xz -f '{}' \;
  '';

  meta = with lib; {
    description = "Realtek r8168 driver";
    longDescription = ''
      A kernel module for Realtek 8168 network cards.
      If you want to use this driver, you might need to blacklist the r8169 driver
      by adding "r8169" to boot.blacklistedKernelModules.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ timokau ];
    broken = kernel.kernelAtLeast "5.17";
  };
}
