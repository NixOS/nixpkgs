{ lib, fetchFromGitHub, kernel, buildModule }:

buildModule rec {
  version = "2.5.0";
  pname = "ena";

  src = fetchFromGitHub {
    owner = "amzn";
    repo = "amzn-drivers";
    rev = "ena_linux_${version}";
    sha256 = "sha256-uOf/1624UtjaZtrk7XyQpeUGdTNVDnzZJZMgU86i+SM=";
  };

  hardeningDisable = [ "pic" ];

  # linux 3.12
  # NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration"; TODO(berdario) unused?

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
    broken = kernel.kernelOlder "4.5" || kernel.kernelAtLeast "5.15";
  };
}
