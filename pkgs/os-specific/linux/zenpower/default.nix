{
  lib,
  stdenv,
  kernel,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "zenpower";
  version = "unstable-2025-12-20";

  src = fetchFromGitHub {
    owner = "AliEmreSenel";
    repo = "zenpower3";
    rev = "dc4f1e2d2f5e26ad5b314497485419cb240e7134";
    hash = "sha256-NvCBog1rAAjbhT9dMOjsmio6lVZ9h36XvOiE7znJdTo=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [ "KERNEL_BUILD=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" ];

  installPhase = ''
    install -D zenpower.ko -t "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/hwmon/zenpower/"
  '';

  meta = {
    inherit (src.meta) homepage;
    description = "Linux kernel driver for reading temperature, voltage(SVI2), current(SVI2) and power(SVI2) for AMD Zen family CPUs";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      alexbakker
      artturin
    ];
    platforms = [ "x86_64-linux" ];
    broken = lib.versionOlder kernel.version "4.14";
  };
}
