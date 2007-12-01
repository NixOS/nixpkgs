{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "sysklogd-1.5";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.infodrom.org/projects/sysklogd/download/sysklogd-1.5.tar.gz;
    sha256 = "0wxpkrznqwz4dy11k90s2sqszwp7d4mlc0ag8288wa193plvhsb1";
  };
}
