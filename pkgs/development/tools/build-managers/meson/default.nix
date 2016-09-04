{ lib, python3Packages, fetchurl }:
python3Packages.buildPythonPackage rec {
  name = "meson-0.32.0";

  src = fetchurl {
    url = "mirror://pypi/m/meson/${name}.tar.gz";
    sha256 = "1i5m4q53sr55aw8kx761kh0rsfwkpq0gfa0c0k3jf66y4aml6n54";
  };

  meta = with lib; {
    homepage = http://mesonbuild.com;
    description = "SCons-like build system that use python as a front-end language and Ninja as a building backend";
    license = licenses.asl20;
    maintainers = with maintainers; [ mbe rasendubi ];
    platforms = platforms.all;
  };
}
