{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "microcode2ucode-20120205";
  src = fetchurl {
    url = "http://pkgs.fedoraproject.org/repo/pkgs/microcode_ctl/intel-microcode2ucode.c/0efc5f6c74a4d7e61ca22683c93c98cf/intel-microcode2ucode.c";
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
    mkdir -p "$out/bin"
    cp intel-microcode2ucode "$out/bin/"
  '';

  meta = {
    homepage = http://www.intel.com;
    description = "Microcode converter for Intel .dat files";
  };
}
