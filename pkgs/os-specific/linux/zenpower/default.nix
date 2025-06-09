{
  lib,
  stdenv,
  kernel,
  fetchFromGitLab,
}:

stdenv.mkDerivation rec {
  pname = "zenpower";
  version = "unstable-2025-02-28";

  src = fetchFromGitLab {
    owner = "shdwchn10";
    repo = "zenpower3";
    rev = "138fa0637b46a0b0a087f2ba4e9146d2f9ba2475";
    sha256 = "sha256-kLtkG97Lje+Fd5FoYf+UlSaEyxFaETtXrSjYzFnHkjY=";
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
