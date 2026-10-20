{
  lib,
  stdenv,
  fetchFromGitLab,
  kernel,
  kernelModuleMakeFlags,
}:

let
  kdir = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
in

stdenv.mkDerivation rec {
  pname = "ddcci-driver";
  version = "0.4.5-unstable-2025-09-27";
  name = "${pname}-${kernel.version}-${version}";

  src = fetchFromGitLab {
    owner = "${pname}-linux";
    repo = "${pname}-linux";
    rev = "bbb7553373f815d78e93a4a9f071ce968563694a";
    hash = "sha256-fQjsDjbtFKhs0bUCFfKRgCg516TXdwIkhKEbIISjgs0=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  prePatch = ''
    substituteInPlace ./ddcci/Makefile \
      --replace '"$(src)"' '$(PWD)'
    substituteInPlace ./ddcci-backlight/Makefile \
      --replace '"$(src)"' '$(PWD)'
  '';

  patches = [
    ./0001-Use-sysfs_emit-and-field-width-specifier.patch
  ];

  makeFlags = kernelModuleMakeFlags ++ [
    "KDIR=${kdir}"
    "KVER=${kernel.modDirVersion}"
  ];

  # Install through Kbuild's `modules_install` instead of the upstream
  # `install` targets, which copy the modules by hand and thereby skip the
  # signing rule that emits the per-module `.ko.cer` certificates
  # `aggregateModules` merges into `modules.cer`.
  installPhase = ''
    runHook preInstall

    for module in ddcci ddcci-backlight; do
      make -C "${kdir}" M="$PWD/$module" modules_install \
        INSTALL_MOD_PATH="$out" INSTALL_MOD_DIR=extra DEPMOD=true $makeFlags
    done

    install -Dm644 include/linux/ddcci.h -t "$out/include/linux"

    runHook postInstall
  '';

  meta = {
    description = "Kernel module driver for DDC/CI monitors";
    homepage = "https://gitlab.com/ddcci-driver-linux/ddcci-driver-linux";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ kiike ];
    platforms = lib.platforms.linux;
    broken = kernel.kernelOlder "5.1";
  };
}
