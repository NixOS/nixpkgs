{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "strace-4.5.12";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/strace/strace-4.5.12.tar.bz2;
    md5 = "c9dc77b9bd7f144f317e8289e0f6d40b";
  };
}
