{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "radeon-r700-firmware-2009-12-09";

  src = fetchurl {
    url = "http://people.freedesktop.org/~agd5f/radeon_ucode/R700_rlc.bin";
    sha256 = "1lbgrlbhqijizg16z0g0qa6ggznpdy844cawnwdp1b0fkwhrbkga";
  };

  unpackPhase = "true";
  installPhase = "install -D $src $out/radeon/R700_rlc.bin";

  meta = {
    description = "Firmware for the RADEON r700 chipset";
    homepage = "http://people.freedesktop.org/~agd5f/radeon_ucode";
    license = "GPL";
  };
}
