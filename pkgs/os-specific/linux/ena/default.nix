{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
}:

stdenv.mkDerivation rec {
  version = "2.12.3";
  name = "ena-${version}-${kernel.version}";

  src = fetchFromGitHub {
    owner = "amzn";
    repo = "amzn-drivers";
    rev = "ena_linux_${version}";
    hash = "sha256-F8vDPPwO0PnGXhqt0EeT4m/+d8w/rjMHWRV3RYC/wVQ=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;
  makeFlags = kernel.makeFlags;

  env.KERNEL_BUILD_DIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  patches = [
    # https://github.com/amzn/amzn-drivers/issues/313
    ./0001-workaround-patch-for-kernel-6.10.patch
  ];

  configurePhase = ''
    runHook preConfigure
    cd kernel/linux/ena
    export ENA_PHC_INCLUDE=1
    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall
    $STRIP -S ena.ko
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
    maintainers = with maintainers; [
      sielicki
      arianvp
    ];
    platforms = platforms.linux;
  };
}
