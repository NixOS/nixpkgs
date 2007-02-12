{stdenv, fetchurl}:

assert stdenv.isLinux;

stdenv.mkDerivation {
  name = "linux-headers-2.6.20";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://ftp.nl.kernel.org/pub/linux/kernel/v2.6/linux-2.6.20.tar.bz2;
    sha256 = "0n455dyvmbs9l0m3hll2rilyrj8gsqqablrhnh1jw9vxmjhss51c";
  };

  platform = 
    if stdenv.system == "i686-linux" then "i386" else
    if stdenv.system == "x86_64-linux" then "x86_64" else
    if stdenv.system == "powerpc-linux" then "powerpc" else
    abort "don't know what the kernel include directory is called for this platform";

  extraIncludeDirs =
    if stdenv.system == "powerpc-linux" then ["ppc"] else [];
}
