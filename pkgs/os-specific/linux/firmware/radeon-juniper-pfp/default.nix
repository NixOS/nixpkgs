{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "radeon-juniper-pfp-firmware-2010-04-08";

  src = fetchurl {
    url = "http://people.freedesktop.org/~agd5f/radeon_ucode/JUNIPER_pfp.bin";
    sha256 = "1qm910p7qjs6n528q22gkwpprzdh39vbihdliykbpfs1pphrhkjz";
  };

  unpackPhase = "true";
  installPhase = "install -D $src $out/radeon/JUNIPER_pfp.bin";

  meta = {
    description = "Juniper-pfp firmware for the RADEON chipset";
    homepage = "http://people.freedesktop.org/~agd5f/radeon_ucode";
    license = "GPL";
  };
}
