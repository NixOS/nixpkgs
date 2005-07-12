{stdenv, fetchurl, coreutils}:

stdenv.mkDerivation {
  name = "findutils-4.2.20";
  src = fetchurl {
    url = http://ftp.gnu.org/gnu/findutils/findutils-4.2.20.tar.gz;
    md5 = "7c8e12165b221dd67a19c00d780437a4";
  };
  buildInputs = [coreutils];
}
