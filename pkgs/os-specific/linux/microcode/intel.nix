{ stdenv, fetchurl }:

let version = "20111110";
    num = "20728";
in stdenv.mkDerivation {
  name = "microcode-intel-${version}";
  src = fetchurl {
    url = "http://downloadmirror.intel.com/${num}/eng/microcode-${version}.tgz";
    sha256 = "16f532cdf9cce03e01e714619ad9406a465aa965bbd1288035398db79921cbc1";
  };

#  setSourceRoot = ''
#    sourceRoot=.
#  '';

  sourceRoot = ".";

  dontBuild = true;
  installPhase = ''
    ensureDir $out
    cp microcode.dat "$out/"
  '';

  meta = {
    homepage = http://www.intel.com;
    description = "Microcode for Intel processors";
  };
}