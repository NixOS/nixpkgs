{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  gitUpdater,
  kernel,
  kernelModuleMakeFlags,
}:
let
  rev-prefix = "ena_linux_";
in
stdenv.mkDerivation (finalAttrs: {
  version = "2.17.2";
  pname = "ena";
  name = "${finalAttrs.pname}-${finalAttrs.version}-${kernel.version}";

  src = fetchFromGitHub {
    owner = "amzn";
    repo = "amzn-drivers";
    rev = "${rev-prefix}${finalAttrs.version}";
    hash = "sha256-v/b4P5twRFaqjkeuXy6UhjnRCxVZ6+Muk80653uXnsY=";
  };

  hardeningDisable = [ "pic" ];

  patches = [
    # Linux 7.2 signature change
    # https://github.com/amzn/amzn-drivers/pull/384
    (fetchpatch2 {
      url = "https://github.com/amzn/amzn-drivers/commit/907a1686e35458b8e3bc5b406609473bee7da39a.patch";
      hash = "sha256-KG85r4m868mc6+QlBdoE06FQcSG2JiDPFHjfRgxfkHY=";
    })
  ];

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
