{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:

let
  KDIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}";
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}-${kernel.version}";
  pname = "asus-ec-sensors";
  version = "0.1.0-unstable-2025-12-11";

  src = fetchFromGitHub {
    owner = "zeule";
    repo = "asus-ec-sensors";
    rev = "0e73cd165c4d1baf8ce841604722c6981b7ba9d6";
    hash = "sha256-qX+HmtBdm9bOJRnlpI/Ru0OCcUi8MQ29Y731yM9JEi0=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "KVER=${kernel.modDirVersion}"
    "KDIR=${KDIR}"
    "INSTALL_MOD_PATH=${placeholder "out"}"
    "MOD_SUBDIR=kernel/drivers/hwmon"
  ];

  installTargets = [ "modules_install" ];

  meta = {
    description = "Linux HWMON sensors driver for ASUS motherboards to read sensor data from the embedded controller";
    homepage = "https://github.com/zeule/asus-ec-sensors";
    license = lib.licenses.gpl2Only;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      nickhu
      mariolopjr
    ];
    broken = kernel.kernelOlder "5.11";
  };
}
