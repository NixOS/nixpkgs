{ lib, stdenv, kernel, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "zenpower";
  version = "0.1.13";

  src = fetchFromGitHub {
    owner = "Ta180m";
    repo = "zenpower3";
    rev = "v${version}";
    sha256 = "sha256-2QScHDwOKN3Psui0M2s2p6D97jjbfe3Us5Nkn2srKC0=";
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
    license = licenses.gpl2;
    maintainers = with maintainers; [ alexbakker artturin ];
    platforms = [ "x86_64-linux" ];
    broken = versionOlder kernel.version "4.14";
  };
}
