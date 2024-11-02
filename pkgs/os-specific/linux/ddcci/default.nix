{ lib, stdenv, fetchFromGitLab, kernel, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "ddcci-driver";
  version = "0.4.4";
  name = "${pname}-${kernel.version}-${version}";

  src = fetchFromGitLab {
    owner = "${pname}-linux";
    repo = "${pname}-linux";
    rev = "v${version}";
    hash = "sha256-4pCfXJcteWwU6cK8OOSph4XlhKTk289QqLxsSWY7cac=";
  };

  patches = [
    # See https://gitlab.com/ddcci-driver-linux/ddcci-driver-linux/-/merge_requests/15
    (fetchpatch {
      name = "fix-build-with-linux68.patch";
      url = "https://gitlab.com/ddcci-driver-linux/ddcci-driver-linux/-/commit/3eb20df68a545d07b8501f13fa9d20e9c6f577ed.patch";
      hash = "sha256-Y1ktYaJTd9DtT/mwDqtjt/YasW9cVm0wI43wsQhl7Bg=";
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

  makeFlags = kernel.makeFlags ++ [
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
