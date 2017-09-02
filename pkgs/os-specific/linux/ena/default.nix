{ lib, stdenv, fetchFromGitHub, kernel, kmod }:

stdenv.mkDerivation rec {
  version = "1.2.0";
  name = "ena-${version}-${kernel.version}";

  src = fetchFromGitHub {
    owner = "amzn";
    repo = "amzn-drivers";
    rev = "ena_linux_${version}";
    sha256 = "0m0jqd6gyk4r43w6p5dvp1djg2qgvyhnzmg53sszlh55mlgla714";
  };

  hardeningDisable = [ "pic" ];

  # linux 3.12
  NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";

  configurePhase =
    ''
      cd kernel/linux/ena
      substituteInPlace Makefile --replace '/lib/modules/$(BUILD_KERNEL)' ${kernel.dev}/lib/modules/${kernel.modDirVersion}
    '';

  installPhase =
    ''
      strip -S ena.ko
      dest=$out/lib/modules/${kernel.modDirVersion}/misc
      mkdir -p $dest
      cp ena.ko $dest/
      xz $dest/ena.ko
    '';

  meta = {
    description = "Amazon Elastic Network Adapter (ENA) driver for Linux";
    homepage = https://github.com/amzn/amzn-drivers;
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.eelco ];
    platforms = lib.platforms.linux;
    broken = kernel.features.chromiumos or false;
  };
}
