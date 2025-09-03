{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation rec {
  name = "asus-ec-sensors-${version}-${kernel.version}";
  version = "0.1.0-unstable-2025-01-10";

  src = fetchFromGitHub {
    owner = "zeule";
    repo = "asus-ec-sensors";
    rev = "619d505b7055be618e9ba9d5e146fd641dbf3015";
    sha256 = "sha256-vS8wNS53m495hmsI267R5Kq/j8Mo5491PJkUKRUpqPQ=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}"
  ];

  installPhase = ''
    install asus-ec-sensors.ko -Dm444 -t ${placeholder "out"}/lib/modules/${kernel.modDirVersion}/kernel/drivers/hwmon
  '';

  meta = with lib; {
    description = "Linux HWMON sensors driver for ASUS motherboards to read sensor data from the embedded controller";
    homepage = "https://github.com/zeule/asus-ec-sensors";
    license = licenses.gpl2Only;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ nickhu ];
    broken = kernel.kernelOlder "5.11";
  };
}
