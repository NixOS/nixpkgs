{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
  kernelModuleInstallHook,
}:

stdenv.mkDerivation (finalAttrs: {
  name = "${finalAttrs.pname}-${finalAttrs.version}-${kernel.version}";
  pname = "tp_smapi";
  version = "0.45";

  src = fetchFromGitHub {
    owner = "linux-thinkpad";
    repo = "tp_smapi";
    tag = "tp-smapi/${finalAttrs.version}";
    hash = "sha256-rB+DNgWUXd1oQBbDgVEAJVJ16nKCaKDtWGAmpcFsx+A=";
  };

  patches = [
    # Linux v7.2 removed function strncpy, have to use strscpy instead.
    # This is an open issue in upstream, patching with upstream PR's commit.
    # This patch should be removed once the PR is merged in upstream.
    #
    # Upstream issue: https://github.com/linux-thinkpad/tp_smapi/issues/82
    # Upstream pull request: https://github.com/linux-thinkpad/tp_smapi/pull/81
    # Upstream commit: https://github.com/linux-thinkpad/tp_smapi/commit/0483993a64f6d922d71dddd8f7f353d8bc22d1bf
    ./0001-use-strscpy-instead-of-strncpy.patch
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies ++ [ kernelModuleInstallHook ];

  hardeningDisable = [ "pic" ];

  makeFlags = [
    "KBASE=${kernel.dev}/lib/modules/${kernel.modDirVersion}"
    "SHELL=${stdenv.shell}"
    "HDAPS=1"
  ];

  kernelModuleInstallDir = "kernel/drivers/firmware";

  # The module file is renamed to avoid clashing with the in-tree hdaps
  # driver of the same name. kbuild's modules_install installs the files
  # listed in modules.order, so keep that in sync before installing.
  preInstall = ''
    mv hdaps.ko hdapsd.ko
    sed -i 's/^hdaps\.o$/hdapsd.o/' modules.order
  '';

  dontStrip = true;

  enableParallelBuilding = true;

  meta = {
    description = "IBM ThinkPad hardware functions driver";
    homepage = "https://github.com/linux-thinkpad/tp_smapi";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    # driver is only meant for linux thinkpads, bellow platforms should cover it.
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };
})
