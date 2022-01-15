{ lib, stdenv, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  version = "2.5.0";
  name = "ena-${version}-${kernel.version}";

  src = fetchFromGitHub {
    owner = "amzn";
    repo = "amzn-drivers";
    rev = "ena_linux_${version}";
    sha256 = "sha256-uOf/1624UtjaZtrk7XyQpeUGdTNVDnzZJZMgU86i+SM=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  # linux 3.12
  NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";

  configurePhase = ''
    runHook preConfigure
    cd kernel/linux/ena
    substituteInPlace Makefile --replace '/lib/modules/$(BUILD_KERNEL)' ${kernel.dev}/lib/modules/${kernel.modDirVersion}
    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall
    strip -S ena.ko
    dest=$out/lib/modules/${kernel.modDirVersion}/misc
    mkdir -p $dest
    cp ena.ko $dest/
    xz $dest/ena.ko
    runHook postInstall
  '';

  meta = with lib; {
    description = "Amazon Elastic Network Adapter (ENA) driver for Linux";
    homepage = "https://github.com/amzn/amzn-drivers";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.eelco ];
    platforms = platforms.linux;
    broken = kernel.kernelOlder "4.5" || kernel.kernelAtLeast "5.15";
  };
}
