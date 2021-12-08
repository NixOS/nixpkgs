{ lib, stdenv, fetchFromGitHub, kernel, buildModule }:

buildModule rec {
  pname = "asus-wmi-sensors-${version}";
  version = "unstable-2019-11-07";

  # The original was deleted from github, but this seems to be an active fork
  src = fetchFromGitHub {
    owner = "electrified";
    repo = "asus-wmi-sensors";
    rev = "8daafd45d1b860cf5b17eee1c94d93feb04164a9";
    sha256 = "0kc0xlrsmf783ln5bqyj6qxzmrhdxdfdd2b9ygf2lbl2153i04vc";
  };

  hardeningDisable = [ "pic" ];

  preConfigure = ''
    sed -i 's|depmod|#depmod|' Makefile
  '';

  makeFlags = [
    "TARGET=${kernel.modDirVersion}"
    "KERNEL_MODULES=${kernel.dev}/lib/modules/${kernel.modDirVersion}"
    "MODDESTDIR=${placeholder "out"}/lib/modules/${kernel.modDirVersion}/kernel/drivers/hwmon"
  ];

  overridePlatforms = [ "x86_64-linux" "i686-linux" ];

  meta = with lib; {
    description = "Linux HWMON (lmsensors) sensors driver for various ASUS Ryzen and Threadripper motherboards";
    homepage = "https://github.com/electrified/asus-wmi-sensors";
    license = licenses.gpl2; 
    maintainers = with maintainers; [ Frostman ];
    broken = versionOlder kernel.version "4.12";
  };
}
