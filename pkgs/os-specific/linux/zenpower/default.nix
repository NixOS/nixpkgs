{ stdenv, kernel, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "zenpower";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "ocerman";
    repo = "zenpower";
    rev = "v${version}";
    sha256 = "1ay1q666bc7czgc95invw523c0ds2gj85wxypc3wi418vfaha5vy";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = "KERNEL_BUILD=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  installPhase = ''
    install -D zenpower.ko -t "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/hwmon/zenpower/"
  '';

  meta = with stdenv.lib; {
    description = "Linux kernel driver for reading temperature, voltage(SVI2), current(SVI2) and power(SVI2) for AMD Zen family CPUs.";
    homepage = "https://github.com/ocerman/zenpower";
    license = licenses.gpl2;
    maintainers = with maintainers; [ alexbakker ];
    platforms = platforms.linux;
    broken = versionOlder kernel.version "4.14";
  };
}
