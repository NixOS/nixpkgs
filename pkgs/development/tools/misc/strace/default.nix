{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "strace-4.5.15";

  src = fetchurl {
    url = mirror://sourceforge/strace/strace-4.5.15.tar.gz;
    sha256 = "07n62yv53p2hsb59srfaxb0kk8b6p6iq77drmf65pq8jpa50s9ip";
  };
}
