{ lib, python3Packages, fetchurl }:
python3Packages.buildPythonPackage rec {
  version = "0.35.0";
  name = "meson-${version}";

  src = fetchurl {
    url = "mirror://pypi/m/meson/${name}.tar.gz";
    sha256 = "0w4vian55cwcv2m5qzn73aznf9a0y24cszqb7dkpahrb9yrg25l3";
  };

  meta = with lib; {
    homepage = http://mesonbuild.com;
    description = "SCons-like build system that use python as a front-end language and Ninja as a building backend";
    license = licenses.asl20;
    maintainers = with maintainers; [ mbe rasendubi ];
    platforms = platforms.all;
  };
}
