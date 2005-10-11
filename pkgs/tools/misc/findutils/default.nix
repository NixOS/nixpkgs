{stdenv, fetchurl, coreutils}:

stdenv.mkDerivation {
  name = "findutils-4.2.25";
  src = fetchurl {
    url = http://ftp.gnu.org/gnu/findutils/findutils-4.2.25.tar.gz;
    md5 = "e92fef6714ffa9972f28a1a423066921";
  };
  buildInputs = [coreutils];
  patches = [./findutils-path.patch];
}
