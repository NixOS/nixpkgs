{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "microcode2ucode-20120205";
  src = fetchurl {
    url = "http://gentoo-overlays.zugaina.org/gentoo/portage/sys-apps/microcode-data/files/intel-microcode2ucode.c";
    sha256 = "c51b1b1d8b4b28e7d5d007917c1e444af1a2ff04a9408aa9067c0e57d70164de";
  };

  sourceRoot = ".";

  unpackPhase = ''
    # nothing to unpack
  '';

  buildPhase = ''
    gcc -Wall -O2 $src -o intel-microcode2ucode
  '';
  
  installPhase = ''
    ensureDir "$out/bin"
    cp intel-microcode2ucode "$out/bin/"
  '';

  meta = {
    homepage = http://www.intel.com;
    description = "Microcode converter for Intel .dat files";
  };
}