{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "radeon-r600-firmware-2009-12-09";

  src = fetchurl {
    url = "http://people.freedesktop.org/~agd5f/radeon_ucode/R600_rlc.bin";
    sha256 = "11bxpivxycigv0ffbck33y9czgira3g8py33840zxzwcwbi59yps";
  };

  unpackPhase = "true";
  installPhase = "install -D $src $out/radeon/R600_rlc.bin";

  meta = {
    description = "Firmware for the RADEON r600 chipset";
    homepage = "http://people.freedesktop.org/~agd5f/radeon_ucode";
    license = "GPL";
  };
}
