{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  cmake,
  kernel,
  kernelModuleMakeFlags,
}:
let
  rev-prefix = "efa_linux_";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "efa";
  version = "3.4.0";
  name = "${finalAttrs.pname}-${finalAttrs.version}-${kernel.version}";

  __structuredAttrs = true;
  strictDeps = true;
  enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "amzn";
    repo = "amzn-drivers";
    tag = "${rev-prefix}${finalAttrs.version}";
    hash = "sha256-F7ysRtUW+8xdrQDQN08/c21iF72aB1lhKAQrjYymbcQ=";
  };

  sourceRoot = "${finalAttrs.src.name}/kernel/linux/efa";

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = [ cmake ] ++ kernel.moduleBuildDependencies;

  postPatch = ''
    patchShebangs --build config
  '';

  makeFlags = kernelModuleMakeFlags;

  cmakeFlags = [
    (lib.cmakeFeature "KERNEL_DIR" "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build")
  ];

  installTargets = [ "modules_install" ];

  installFlags = kernelModuleMakeFlags ++ [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(PWD)/src"
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ];

  passthru.updateScript = gitUpdater {
    inherit rev-prefix;
  };

  meta = {
    description = "Amazon Elastic Fabric Adapter (EFA) driver for Linux";
    homepage = "https://github.com/amzn/amzn-drivers";
    license = with lib.licenses; [
      bsd2
      gpl2Only
    ];
    maintainers = with lib.maintainers; [
      sielicki
      ethancedwards8
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
