{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation rec {
  name = "liquidtux-${version}-${kernel.version}";
  version = "0.1.0-unstable-2025-01-16";

  src = fetchFromGitHub {
    owner = "liquidctl";
    repo = "liquidtux";
    rev = "4613127ac6a7f1f0a98009045ea8c16f6b960533";
    sha256 = "sha256-68W7n3QWoAO07FDW45ualpOo5Cty6vcQt/9cLtlnDX0=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    runHook preInstall
    cd drivers/hwmon
    install nzxt-grid3.ko nzxt-kraken2.ko nzxt-kraken3.ko nzxt-smart2.ko -Dm444 -t ${placeholder "out"}/lib/modules/${kernel.modDirVersion}/kernel/drivers/hwmon
    runHook postInstall
  '';

  meta = with lib; {
    description = "Linux kernel hwmon drivers for AIO liquid coolers and other devices";
    homepage = "https://github.com/liquidctl/liquidtux";
    license = licenses.gpl2Only;
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    maintainers = with maintainers; [ nickhu ];
    broken = lib.versionOlder kernel.version "5.10";
  };
}
