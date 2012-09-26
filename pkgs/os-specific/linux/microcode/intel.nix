{ stdenv, fetchurl, microcode2ucode }:

let version = "20120606";
    num = "21385";
in stdenv.mkDerivation {
  name = "microcode-intel-${version}";
  src = fetchurl {
    url = "http://downloadmirror.intel.com/${num}/eng/microcode-${version}.tgz";
    sha256 = "0hs95lj24zx3jscc64zg3hf8xc95vrnsyqlid66h453ib0wf8fg1";
  };

  buildInputs = [ microcode2ucode ];
  sourceRoot = ".";

  buildPhase = ''
    intel-microcode2ucode microcode.dat
  '';

  installPhase = ''
    ensureDir $out
    cp -r intel-ucode "$out/"
  '';

  meta = {
    homepage = http://www.intel.com/;
    description = "Microcode for Intel processors";
  };
}
