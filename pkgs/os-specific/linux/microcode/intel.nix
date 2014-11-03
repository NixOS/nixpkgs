{ stdenv, fetchurl, microcode2ucode }:

let version = "20140624"; in

stdenv.mkDerivation {
  name = "microcode-intel-${version}";

  src = fetchurl {
    url = "http://downloadmirror.intel.com/23984/eng/microcode-${version}.tgz";
    sha256 = "0dza0bdlx7q88yhnynvfgkrhgf7ycrq6mlp6hwnpp2j3h33jlrml";
  };

  buildInputs = [ microcode2ucode ];

  sourceRoot = ".";

  buildPhase = ''
    intel-microcode2ucode microcode.dat
  '';

  installPhase = ''
    mkdir -p $out/lib/firmware
    cp -r intel-ucode "$out/lib/firmware/"
  '';

  meta = {
    homepage = http://www.intel.com/;
    description = "Microcode for Intel processors";
    license = stdenv.lib.licenses.unfree;
  };
}
