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
  version = "2.13.2";
in
stdenv.mkDerivation {
  inherit version;
  name = "ena-${version}-${kernel.version}";

  src = fetchFromGitHub {
    owner = "amzn";
    repo = "amzn-drivers";
    rev = "${rev-prefix}${version}";
    hash = "sha256-v4S23lG3DGcsLcxwl4F11UlN7xD69mg0yS4fWs89+kM=";
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
