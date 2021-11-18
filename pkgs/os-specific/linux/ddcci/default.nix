{ lib, stdenv, fetchpatch, fetchFromGitLab, kernel }:

stdenv.mkDerivation rec {
  pname = "ddcci-driver";
  # XXX: We apply a patch for the upcoming version to the source of version 0.4.1
  # XXX: When 0.4.2 is actually released, don't forget to remove this comment,
  # XXX: fix the rev in fetchFromGitLab, and remove the patch.
  version = "0.4.2";
  name = "${pname}-${kernel.version}-${version}";

  src = fetchFromGitLab {
    owner = "${pname}-linux";
    repo = "${pname}-linux";
    rev = "v0.4.1";
    sha256 = "1qhsm0ccwfmwn0r6sbc6ms4lf4a3iqfcgqmbs6afr6hhxkqll3fg";
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

  patches = [
    (fetchpatch {
      url = "https://gitlab.com/ddcci-driver-linux/ddcci-driver-linux/-/commit/bf9d79852cbd0aa5c2e288ce51b8280f74a1f5d2.patch";
      sha256 = "sha256-ShqVzkoRnlX4Y5ARY11YVYatFI1K7bAtLulP3/8/nwg=";
    })
  ];

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
