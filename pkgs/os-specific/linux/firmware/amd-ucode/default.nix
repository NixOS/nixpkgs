{ stdenv, fetchurl }:

stdenv.mkDerivation rec {

  name = "amd-ucode-2012-01-17";

  src = fetchurl {
    url = "http://www.amd64.org/pub/microcode/${name}.tar";
    sha256 = "0mqnbs87khv6p874cbyf9nb8i4gc592ws67lyzhc4chmwvc9ln47";
  };

  installPhase = ''
    mkdir -p $out/amd-ucode
    mv microcode_amd_fam15h.bin microcode_amd.bin $out/amd-ucode/
  '';

  meta = {
    description = "AMD Processor Microcode Patch";
    homepage = "http://www.amd64.org/support/microcode.html";
    license = "non-free";
  };
}
