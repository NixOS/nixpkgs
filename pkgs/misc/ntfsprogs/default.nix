{stdenv, fetchurl, libuuid}:

stdenv.mkDerivation rec {
  name = "ntfsprogs-2.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/linux-ntfs/${name}.tar.bz2";
    sha256 = "ad36e19706c7303b10aa0a9bf2c2dd0309b91cd0171f1c9eb361d94a85017432";
  };

  buildInputs = [libuuid];

  preConfigure =
    ''
      substituteInPlace ntfsprogs/Makefile.in --replace /sbin $out/sbin
    '';

  meta = {
    description = "Utilities for the NTFS filesystem";
    homepage = http://sourceforge.net/projects/linux-ntfs;
    license = "GPL";
  };
}
