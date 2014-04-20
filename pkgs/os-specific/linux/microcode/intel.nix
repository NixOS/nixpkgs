{ stdenv, fetchurl, microcode2ucode }:

let version = "20140122"; in

stdenv.mkDerivation {
  name = "microcode-intel-${version}";

  src = fetchurl {
    url = "http://downloadmirror.intel.com/23574/eng/microcode-${version}.tgz";
    sha256 = "0r5ldb1jvrf0b6b112v3wdr7ikf2zky2jgby2lnqi1xwd34x42k8";
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
