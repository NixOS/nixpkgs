{ lib, stdenv, fetchFromGitLab, kernel, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "ddcci-driver";
  version = "0.4.3";
  name = "${pname}-${kernel.version}-${version}";

  src = fetchFromGitLab {
    owner = "${pname}-linux";
    repo = "${pname}-linux";
    rev = "v${version}";
    hash = "sha256-1Z6V/AorD4aslLKaaCZpmkD2OiQnmpu3iroOPlNPtLE=";
  };

  patches = [
    # https://gitlab.com/ddcci-driver-linux/ddcci-driver-linux/-/merge_requests/12
    (fetchpatch {
      name = "kernel-6.2-6.3.patch";
      url = "https://gitlab.com/ddcci-driver-linux/ddcci-driver-linux/-/commit/1ef6079679acc455f75057dd7097b5b494a241dc.patch";
      hash = "sha256-2C2leS20egGY3J2tq96gsUQXYw13wBJ3ZWrdIXxmEYs=";
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
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
    broken = kernel.kernelOlder "5.1";
  };
}
