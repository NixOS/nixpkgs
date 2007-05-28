{stdenv, fetchurl}:

assert stdenv.isLinux;

stdenv.mkDerivation {
  name = "linux-headers-2.6.20.7";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nl.kernel.org/pub/linux/kernel/v2.6/linux-2.6.20.7.tar.bz2;
    sha256 = "856f5eb3606061bddb38642fe7068cfc184b4b8fc364fdd8612148a5aca5cea8";
  };

  platform = 
    if stdenv.system == "i686-linux" then "i386" else
    if stdenv.system == "x86_64-linux" then "x86_64" else
    if stdenv.system == "powerpc-linux" then "powerpc" else
    abort "don't know what the kernel include directory is called for this platform";

  extraIncludeDirs =
    if stdenv.system == "powerpc-linux" then ["ppc"] else [];
}
