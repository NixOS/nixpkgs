{stdenv, fetchurl}:

assert stdenv.isLinux;

stdenv.mkDerivation {
  name = "linux-headers-2.6.21.3";
  builder = ./builder.sh;
  src = fetchurl {
    url = "http://ftp.de.kernel.org/pub/linux/kernel/v2.6/linux-2.6.21.3.tar.bz2";
    sha256 = "17rxvw42z4amijb8nya54c2h6bb8gnxnr628arv8shmsccf8qsp5";
  };

  platform = 
    if stdenv.system == "i686-linux" then "i386" else
    if stdenv.system == "x86_64-linux" then "x86_64" else
    if stdenv.system == "powerpc-linux" then "powerpc" else
    abort "don't know what the kernel include directory is called for this platform";

  extraIncludeDirs =
    if stdenv.system == "powerpc-linux" then ["ppc"] else [];
}
