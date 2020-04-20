{ stdenv, kernel, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "zenpower";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "ocerman";
    repo = "zenpower";
    rev = "v${version}";
    sha256 = "1fqqaj7fq49yi2yip518036w80r9w7mkxpbkrxqzlydpma1x9v5m";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [ "KERNEL_BUILD=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" ];

  installPhase = ''
    install -D zenpower.ko -t "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/hwmon/zenpower/"
  '';

  meta = with stdenv.lib; {
    description = "Linux kernel driver for reading temperature, voltage(SVI2), current(SVI2) and power(SVI2) for AMD Zen family CPUs.";
    homepage = "https://github.com/ocerman/zenpower";
    license = licenses.gpl2;
    maintainers = with maintainers; [ alexbakker ];
    platforms = [ "x86_64-linux" ];
    broken = versionOlder kernel.version "4.14";
  };
}
