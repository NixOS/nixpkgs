{stdenv, fetchurl}: derivation {
  # !!! check that this is a i386
  name = "linux-headers-2.4.22-i386";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nl.kernel.org/pub/linux/kernel/v2.4/linux-2.4.22.tar.bz2;
    md5 = "75dc85149b06ac9432106b8941eb9f7b";
  };
  stdenv = stdenv;
}
