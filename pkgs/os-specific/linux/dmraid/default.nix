{ stdenv, fetchurl, devicemapper }:

stdenv.mkDerivation rec {
  name = "dmraid-1.0.0.rc16";

  src = fetchurl {
    url = "http://people.redhat.com/~heinzm/sw/dmraid/src/old/${name}.tar.bz2";
    sha256 = "0m92971gyqp61darxbiri6a48jz3wq3gkp8r2k39320z0i6w8jgq";
  };

  patches = [ ./hardening-format.patch ];

  postPatch = ''
    sed -i 's/\[\[[^]]*\]\]/[ "''$''${n##*.}" = "so" ]/' */lib/Makefile.in
  '';

  preConfigure = "cd */";

  buildInputs = [ devicemapper ];

  meta = {
    description = "Old-style RAID configuration utility";
    longDescription = ''
      Old RAID configuration utility (still under development, though).
      It is fully compatible with modern kernels and mdadm recognizes
      its volumes. May be needed for rescuing an older system or nuking
      the metadata when reformatting.
    '';
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.linux;
  };
}
