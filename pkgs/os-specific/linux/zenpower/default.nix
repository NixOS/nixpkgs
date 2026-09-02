{
  lib,
  stdenv,
  kernel,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "zenpower";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "AliEmreSenel";
    repo = "zenpower3";
    tag = "v${version}";
    hash = "sha256-ro40bIMPkM3rLraZaKqzB8a14zgldMIW4jSUr5GbELo=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [ "KERNEL_BUILD=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" ];

  installPhase = ''
    install -D zenpower.ko -t "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/hwmon/zenpower/"
  '';

  passthru.updateScript = nix-update-script { };

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
