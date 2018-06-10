{ lib, stdenv, fetchFromGitHub, kernel, kmod }:

stdenv.mkDerivation rec {
  version = "1.5.2";
  name = "ena-${version}-${kernel.version}";

  src = fetchFromGitHub {
    owner = "amzn";
    repo = "amzn-drivers";
    rev = "ena_linux_${version}";
    sha256 = "18wf36092kr3zlpnqdkcdlim3vvjxy5f24zzsv4fwa7xg12mcfjm";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  # linux 3.12
  NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";

  configurePhase = ''
    cd kernel/linux/ena
    substituteInPlace Makefile --replace '/lib/modules/$(BUILD_KERNEL)' ${kernel.dev}/lib/modules/${kernel.modDirVersion}
  '';

  installPhase = ''
    strip -S ena.ko
    dest=$out/lib/modules/${kernel.modDirVersion}/misc
    mkdir -p $dest
    cp ena.ko $dest/
    xz $dest/ena.ko
  '';

  meta = with stdenv.lib; {
    description = "Amazon Elastic Network Adapter (ENA) driver for Linux";
    homepage = https://github.com/amzn/amzn-drivers;
    license = licenses.gpl2;
    maintainers = [ maintainers.eelco ];
    platforms = platforms.linux;
  };
}
