{ stdenv, fetchurl, iucode_tool }:
let
  version = "3.20171215.1";
in
stdenv.mkDerivation {
  name = "micorcode-intel-debian-${version}";

  nativeBuildInputs = [ iucode_tool ];

  src = fetchurl {
    url = "http://http.debian.net/debian/pool/non-free/i/intel-microcode/intel-microcode_${version}.tar.xz";
    sha256 = "0kgs3wk1xlcmpav106jwz9wi0z2p57i7fi104f3nlifwlv0fza7c";
  };

  installPhase = ''
    mkdir -p $out
    ${iucode_tool}/bin/iucode_tool -l --write-earlyfw="$out/intel-ucode.img" intel-microcode.bin intel-microcode.bin intel-microcode-64.bin
  '';

  meta = with stdenv.lib; {
    homepage = http://www.intel.com/;
    description = "Microcode for Intel processors (with debian supplementary files)";
    license = licenses.unfreeRedistributableFirmware;
    platforms = platforms.linux;
  };
}
