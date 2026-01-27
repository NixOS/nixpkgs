{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  kernel,
  kernelModuleMakeFlags,
}:
let
  rev-prefix = "ena_linux_";
  version = "2.16.1";
in
stdenv.mkDerivation {
  inherit version;
  name = "ena-${version}-${kernel.version}";

  src = fetchFromGitHub {
    owner = "amzn";
    repo = "amzn-drivers";
    rev = "${rev-prefix}${version}";
    hash = "sha256-P31M9WVpAQAcjKCk3bE4I1EMS12a665kXC2b6BOOPaU=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;
  makeFlags = kernelModuleMakeFlags;

  env.KERNEL_BUILD_DIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

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

  passthru.updateScript = gitUpdater {
    inherit rev-prefix;
  };

  meta = {
    description = "Amazon Elastic Network Adapter (ENA) driver for Linux";
    homepage = "https://github.com/amzn/amzn-drivers";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      sielicki
      arianvp
    ];
    platforms = lib.platforms.linux;
  };
}
