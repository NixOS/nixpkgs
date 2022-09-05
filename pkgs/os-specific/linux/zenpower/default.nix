{ lib, stdenv, kernel, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "zenpower";
  version = "unstable-2022-04-13";

  src = fetchFromGitHub {
    owner = "Ta180m";
    repo = "zenpower3";
    rev = "c36a86c64b802e9b90b5166caee6a8e8eddaeb56";
    sha256 = "1i9ap7xgab421f3c68mcmad25xs4h8pfz0g0f9yzg7hxpmb0npxi";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [ "KERNEL_BUILD=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" ];

  installPhase = ''
    install -D zenpower.ko -t "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/hwmon/zenpower/"
  '';

  meta = with lib; {
    description = "Linux kernel driver for reading temperature, voltage(SVI2), current(SVI2) and power(SVI2) for AMD Zen family CPUs.";
    homepage = "https://github.com/Ta180m/zenpower3";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ alexbakker artturin ];
    platforms = [ "x86_64-linux" ];
    broken = versionOlder kernel.version "4.14";
  };
}
