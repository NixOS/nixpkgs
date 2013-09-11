{ stdenv, fetchurl, microcode2ucode }:

let version = "20130808"; in

stdenv.mkDerivation {
  name = "microcode-intel-${version}";

  src = fetchurl {
    url = "http://downloadmirror.intel.com/23082/eng/microcode-${version}.tgz";
    sha256 = "19v0059v6dxv7ly57wgqy9nkjjnmprgwz4s94khdf213k5vikpfm";
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
