{stdenv, fetchurl, dietgcc}:

stdenv.mkDerivation {
  name = "gnused-4.1.4";
  src = fetchurl {
    url = http://ftp.gnu.org/gnu/sed/sed-4.1.4.tar.gz;
    md5 = "2a62ceadcb571d2dac006f81df5ddb48";
  };
  NIX_GCC=dietgcc;
  NIX_GLIBC_FLAGS_SET=1;
  NIX_CFLAGS_COMPILE="-D_BSD_SOURCE=1";
}
