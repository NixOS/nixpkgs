{ lib, fetchFromGitHub, kernel, buildModule }:

buildModule rec {
  pname = "it87";
  version = "2018-08-14";

  # The original was deleted from github, but this seems to be an active fork
  src = fetchFromGitHub {
    owner = "hannesha";
    repo = "it87";
    rev = "5515f5b78838cb6be551943ffef5d1792012724c";
    sha256 = "1ygi4mwds4q7byhg8gqnh3syamdj5rpjy3jj012k7vl54gdgrmgm";
  };

  hardeningDisable = [ "pic" ];

  preConfigure = ''
    sed -i 's|depmod|#depmod|' Makefile
  '';

  makeFlags = [
    "TARGET=${kernel.modDirVersion}"
    "KERNEL_MODULES=${kernel.dev}/lib/modules/${kernel.modDirVersion}"
    "MODDESTDIR=$(out)/lib/modules/${kernel.modDirVersion}/kernel/drivers/hwmon"
  ];

  overridePlatforms = [ "x86_64-linux" "i686-linux" ];

  meta = with lib; {
    description = "Patched module for IT87xx superio chip sensors support";
    homepage = "https://github.com/hannesha/it87";
    license = licenses.gpl2;
    maintainers = with maintainers; [ yorickvp ];
  };
}
