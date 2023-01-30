{ lib, stdenv, fetchFromGitLab, kernel, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "ddcci-driver";
  version = "0.4.2";
  name = "${pname}-${kernel.version}-${version}";

  src = fetchFromGitLab {
    owner = "${pname}-linux";
    repo = "${pname}-linux";
    rev = "v${version}";
    sha256 = "sSmL8PqxqHHQiume62si/Kc9El58/b4wkB93iG0dnNM=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  prePatch = ''
    substituteInPlace ./ddcci/Makefile \
      --replace '"$(src)"' '$(PWD)' \
      --replace depmod \#
    substituteInPlace ./ddcci-backlight/Makefile \
      --replace '"$(src)"' '$(PWD)' \
      --replace depmod \#
  '';

  makeFlags = kernel.makeFlags ++ [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "KVER=${kernel.modDirVersion}"
    "KERNEL_MODLIB=$(out)/lib/modules/${kernel.modDirVersion}"
    "INCLUDEDIR=$(out)/include"
  ];

  patches = [
    # fix to support linux 6.1
    (fetchpatch {
      url = "https://gitlab.com/ddcci-driver-linux/ddcci-driver-linux/-/commit/ce52d6ac5e5ed7119a0028eed8823117a004766e.patch";
      sha256 = "sha256-Tmf4oiMWLR5ma/3X0eoFuriK29HwDqy6dBT7WdqE3mI=";
    })
  ];

  meta = with lib; {
    description = "Kernel module driver for DDC/CI monitors";
    homepage = "https://gitlab.com/ddcci-driver-linux/ddcci-driver-linux";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
    broken = kernel.kernelOlder "5.1";
  };
}
