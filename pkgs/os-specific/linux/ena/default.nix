{ lib, stdenv, fetchFromGitHub, kernel, kmod }:

stdenv.mkDerivation rec {
  name = "ena-20160629-${kernel.version}";

  src = fetchFromGitHub {
    owner = "amzn";
    repo = "amzn-drivers";
    rev = "b594ac1ea9e0c70e8e95803a0cfd9f5f06ac097e";
    sha256 = "03w6xgv3lfn28n38mj9cdi3px5zjyrbxnflpd3ggivkv6grf9fp7";
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
  };
}
