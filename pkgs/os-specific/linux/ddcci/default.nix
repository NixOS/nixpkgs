{
  lib,
  stdenv,
  fetchFromGitLab,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation rec {
  pname = "ddcci-driver";
  version = "0.4.5-unstable-2025-09-27";
  name = "${pname}-${kernel.version}-${version}";

  __structuredAttrs = true;
  strictDeps = true;
  enableParallelBuilding = true;

  src = fetchFromGitLab {
    owner = "${pname}-linux";
    repo = "${pname}-linux";
    rev = "bbb7553373f815d78e93a4a9f071ce968563694a";
    hash = "sha256-fQjsDjbtFKhs0bUCFfKRgCg516TXdwIkhKEbIISjgs0=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  patches = [
    ./0001-Use-sysfs_emit-and-field-width-specifier.patch
  ];

  makeFlags = kernelModuleMakeFlags ++ [
    "KERNELRELEASE=${kernel.modDirVersion}"
  ];

  installFlags = [
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ];

  buildPhase = ''
    runHook preBuild
    make modules -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build M=$(pwd)/ddcci "''${makeFlags[@]}"
    make modules -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build M=$(pwd)/ddcci-backlight "''${makeFlags[@]}"
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    make modules_install -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build M=$(pwd)/ddcci \
      "''${makeFlags[@]}" "''${installFlags[@]}"
    make modules_install -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build M=$(pwd)/ddcci-backlight \
      "''${makeFlags[@]}" "''${installFlags[@]}"
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
