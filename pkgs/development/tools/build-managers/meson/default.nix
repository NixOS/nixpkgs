{ lib, python3Packages, fetchurl }:
python3Packages.buildPythonPackage rec {
  version = "0.39.0";
  name = "meson-${version}";

  src = fetchurl {
    url = "mirror://pypi/m/meson/${name}.tar.gz";
    sha256 = "eac71036ae0e7c692873880fd32c55ca28e99f56630d118ca9c78fbd986c6c97";
  };

  meta = with lib; {
    homepage = http://mesonbuild.com;
    description = "SCons-like build system that use python as a front-end language and Ninja as a building backend";
    license = licenses.asl20;
    maintainers = with maintainers; [ mbe rasendubi ];
    platforms = platforms.all;
  };
}
