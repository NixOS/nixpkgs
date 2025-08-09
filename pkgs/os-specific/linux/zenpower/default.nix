{
  lib,
  stdenv,
  kernel,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "zenpower";
  version = "unstable-2025-06-17";

  src = fetchFromGitHub {
    owner = "AliEmreSenel";
    repo = "zenpower3";
    rev = "41e042935ee9840c0b9dd55d61b6ddd58bc4fde6";
    hash = "sha256-0U/JmEd6OJJeUm1ZLFYxpKH15n7+QTWYOgtKIFAuf/4=";
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
    maintainers = with maintainers; [
      alexbakker
      artturin
    ];
    platforms = [ "x86_64-linux" ];
    broken = versionOlder kernel.version "4.14";
  };
}
