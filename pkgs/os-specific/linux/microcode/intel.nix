{ stdenv, fetchurl, microcode2ucode }:

let version = "20130906"; in

stdenv.mkDerivation {
  name = "microcode-intel-${version}";

  src = fetchurl {
    url = "http://downloadmirror.intel.com/23166/eng/microcode-${version}.tgz";
    sha256 = "11k327icvijadq2zkgkc3sqwzraip9cviqm25566g09523ds0svv";
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
