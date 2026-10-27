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
  version = "2.17.4";
  pname = "ena";
  name = "${finalAttrs.pname}-${finalAttrs.version}-${kernel.version}";

  __structuredAttrs = true;
  strictDeps = true;
  enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "amzn";
    repo = "amzn-drivers";
    rev = "${rev-prefix}${finalAttrs.version}";
    hash = "sha256-C4nw+RhBukUuSVMpXZ1hlpwxk58KgM+kpdht+BywbZ4=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

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

  installFlags = kernelModuleMakeFlags ++ [
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ];

  installPhase = ''
    runHook preInstall
    make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build M=$(pwd) modules_install \
      "''${makeFlags[@]}" "''${installFlags[@]}"
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
