{stdenv, fetchurl}:

stdenv.mkDerivation {
  builder = ./builder.sh;
  name = "libsepol-1.12";
  src = fetchurl {
    url = http://www.nsa.gov/selinux/archives/libsepol-1.12.tgz;
    md5 = "937885f1fcbfe597a0f02aa9af044710";
  };
}
