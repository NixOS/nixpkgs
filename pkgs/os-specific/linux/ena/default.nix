{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
}:

stdenv.mkDerivation rec {
  version = "2.12.0";
  name = "ena-${version}-${kernel.version}";

  src = fetchFromGitHub {
    owner = "amzn";
    repo = "amzn-drivers";
    rev = "ena_linux_${version}";
    hash = "sha256-Z/eeIUY7Yl2l/IqK3Z2nxPhn+JLvP976IZ9ZXPBqoSo=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;
  makeFlags = kernel.makeFlags;

  # linux 3.12
  env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";

  patches = [
    # Use kernel version checks instead of API feature detection
    # See https://github.com/NixOS/nixpkgs/pull/310680
    ./override-features-api-detection.patch
  ];

  configurePhase = ''
    runHook preConfigure
    cd kernel/linux/ena
    export ENA_PHC_INCLUDE=1
    substituteInPlace Makefile --replace '/lib/modules/$(BUILD_KERNEL)' ${kernel.dev}/lib/modules/${kernel.modDirVersion}
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
      eelco
      sielicki
    ];
    platforms = platforms.linux;
  };
}
