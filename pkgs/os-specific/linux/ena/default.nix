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
in
stdenv.mkDerivation (finalAttrs: {
  version = "2.17.0";
  pname = "ena";
  name = "${finalAttrs.pname}-${finalAttrs.version}-${kernel.version}";

  src = fetchFromGitHub {
    owner = "amzn";
    repo = "amzn-drivers";
    rev = "${rev-prefix}${finalAttrs.version}";
    hash = "sha256-Yt8fF73lN5+wKEMtiSFToJMLv63EkfZI/WJfC9ae8H8=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;
  makeFlags = kernelModuleMakeFlags;

  env.KERNEL_BUILD_DIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  postPatch = ''
    substituteInPlace kernel/linux/ena/configure.sh --replace-fail '^HOSTCC' '^CC'
  '';
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
})
