{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  bc,
}:

let
  KDIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
in
stdenv.mkDerivation {
  pname = "rtl8821cu";
  version = "${kernel.version}-unstable-2025-12-15";

  src = fetchFromGitHub {
    owner = "morrownr";
    repo = "8821cu-20210916";
    rev = "7f63a9da2e8ed83403f6f920e9b1628a37b38ef4";
    hash = "sha256-RgGO6r2mx6MiDOWpPJIC0MvX7rejWu+TdHWtsW1PNOY=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = [ bc ] ++ kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "INSTALL_MOD_PATH=${placeholder "out"}"
    "INSTALL_MOD_DIR=kernel/net/wireless"
  ];

  prePatch = ''
    substituteInPlace ./Makefile \
      --replace-fail /lib/modules/ "${kernel.dev}/lib/modules/" \
      --replace-fail /sbin/depmod \# \
      --replace-fail '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  installTargets = [ "modules_install" ];

  installFlags = [
    "-C"
    "${KDIR}"
    "M=$(PWD)"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Realtek rtl8821cu driver";
    homepage = "https://github.com/morrownr/8821cu-20210916";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ contrun ];
  };
}
