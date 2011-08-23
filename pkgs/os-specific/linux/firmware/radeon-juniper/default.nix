{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "radeon-juniper-firmware-2010-04-08";

  srcPfp = fetchurl {
    url = "http://people.freedesktop.org/~agd5f/radeon_ucode/JUNIPER_pfp.bin";
    sha256 = "1qm910p7qjs6n528q22gkwpprzdh39vbihdliykbpfs1pphrhkjz";
  };
  srcMe = fetchurl {
    url = "http://people.freedesktop.org/~agd5f/radeon_ucode/JUNIPER_me.bin";
    sha256 = "1869dhay3f75hhnsvdjhlrjd4fhdi8d6c3lhk45vp7fhjiw4741q";
  };
  srcRlc = fetchurl {
    url = "http://people.freedesktop.org/~agd5f/radeon_ucode/JUNIPER_rlc.bin";
    sha256 = "1y3xr7qc7cvszgw0bh66vzy36pn4m1sj17bzy5dc9kfw01kq3n0y";
  };

  unpackPhase = "true";
  installPhase = ''
    install -D $srcPfp $out/radeon/JUNIPER_pfp.bin
    install -D $srcMe $out/radeon/JUNIPER_me.bin
    install -D $srcRlc $out/radeon/JUNIPER_rlc.bin
  '';

  meta = {
    description = "Juniper firmware for the RADEON chipset";
    homepage = "http://people.freedesktop.org/~agd5f/radeon_ucode";
    license = "GPL";
  };
}
