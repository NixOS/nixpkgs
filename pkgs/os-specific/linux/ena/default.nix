{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  gitUpdater,
  kernel,
  kernelModuleHook,
}:
let
  rev-prefix = "ena_linux_";
in
stdenv.mkDerivation (finalAttrs: {
  version = "2.17.2";
  pname = "ena";
  name = "${finalAttrs.pname}-${finalAttrs.version}-${kernel.version}";

  __structuredAttrs = true;
  strictDeps = true;

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

  nativeBuildInputs = [ kernelModuleHook ];

  env.KERNEL_BUILD_DIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  postPatch = ''
    substituteInPlace kernel/linux/ena/configure.sh --replace-fail '^HOSTCC' '^CC'
  '';

  kbuildDirectories = [ "kernel/linux/ena" ];

  preBuild = ''
    make -C kernel/linux/ena config.h
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
