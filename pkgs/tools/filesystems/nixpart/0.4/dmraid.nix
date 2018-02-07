{ stdenv, fetchurl, devicemapper }:

stdenv.mkDerivation rec {
  name = "dmraid-1.0.0.rc15";

  src = fetchurl {
    url = "http://people.redhat.com/~heinzm/sw/dmraid/src/old/${name}.tar.bz2";
    sha256 = "01bcaq0sc329ghgj7f182xws7jgjpdc41bvris8fsiprnxc7511h";
  };

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
