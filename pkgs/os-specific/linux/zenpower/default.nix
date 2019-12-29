{ stdenv, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  name = "zenpower-${version}";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "ocerman";
    repo = "zenpower";
    rev = "3406cda35c44013a181a535e852c65985f45e242";
    sha256 = "1ay1q666bc7czgc95invw523c0ds2gj85wxypc3wi418vfaha5vy";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = "KERNEL_MODULES=${kernel.dev}/lib/modules/${kernel.modDirVersion}/";

  installPhase = let
    modDestDir = "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/hwmon/zenpower";
  in ''
    mkdir -p ${modDestDir}
    cp zenpower.ko ${modDestDir}
  '';

  meta = with stdenv.lib; {
    description = "Driver for reading sensors data for AMD Zen family CPUs.";
    homepage = https://github.com/ocerman/zenpower;
    license = licenses.unfree; # actually, not specified
    maintainers = with maintainers; [ wedens ];
    platforms = platforms.linux;
    longDescription = ''
      Zenpower is Linux kernel driver for reading temperature, voltage(SVI2), current(SVI2) and power(SVI2) for AMD Zen family CPUs.
    '';
  };
}
