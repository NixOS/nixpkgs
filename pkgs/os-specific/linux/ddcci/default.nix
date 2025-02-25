{
  lib,
  stdenv,
  fetchFromGitLab,
  kernel,
  kernelModuleMakeFlags,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "ddcci-driver";
  version = "0.4.5-unstable-2024-09-26";
  name = "${pname}-${kernel.version}-${version}";

  src = fetchFromGitLab {
    owner = "${pname}-linux";
    repo = "${pname}-linux";
    rev = "0233e1ee5eddb4b8a706464f3097bad5620b65f4";
    hash = "sha256-Osvojt8UE+cenOuMoSY+T+sODTAAKkvY/XmBa5bQX88=";
  };

  patches = [
    # See https://gitlab.com/ddcci-driver-linux/ddcci-driver-linux/-/merge_requests/17
    (fetchpatch {
      url = "https://gitlab.com/ddcci-driver-linux/ddcci-driver-linux/-/commit/e0605c9cdff7bf3fe9587434614473ba8b7e5f63.patch";
      hash = "sha256-sTq03HtWQBd7Wy4o1XbdmMjXQE2dG+1jajx4HtwBHjM=";
    })
  ];

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

  makeFlags = kernelModuleMakeFlags ++ [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "KVER=${kernel.modDirVersion}"
    "KERNEL_MODLIB=$(out)/lib/modules/${kernel.modDirVersion}"
    "INCLUDEDIR=$(out)/include"
  ];

  meta = with lib; {
    description = "Kernel module driver for DDC/CI monitors";
    homepage = "https://gitlab.com/ddcci-driver-linux/ddcci-driver-linux";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ kiike ];
    platforms = platforms.linux;
    broken = kernel.kernelOlder "5.1";
  };
}
