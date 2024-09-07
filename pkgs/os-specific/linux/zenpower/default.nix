{ lib, stdenv, kernel, fetchFromGitea }:

stdenv.mkDerivation rec {
  pname = "zenpower";
  version = "unstable-2022-11-04";

  src = fetchFromGitea {
    domain = "git.exozy.me";
    owner = "a";
    repo = "zenpower3";
    rev = "c176fdb0d5bcba6ba2aba99ea36812e40f47751f";
    sha256 = "sha256-d2WH8Zv7F0phZmEKcDiaak9On+Mo9bAFhMulT/N5FWI=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [ "KERNEL_BUILD=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" ];

  installPhase = ''
    install -D zenpower.ko -t "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/hwmon/zenpower/"
  '';

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Linux kernel driver for reading temperature, voltage(SVI2), current(SVI2) and power(SVI2) for AMD Zen family CPUs";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ alexbakker artturin ];
    platforms = [ "x86_64-linux" ];
    broken = versionOlder kernel.version "4.14";
  };
}
