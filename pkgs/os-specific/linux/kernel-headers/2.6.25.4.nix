{stdenv, fetchurl}:

assert stdenv.isLinux;

stdenv.mkDerivation {
  name = "linux-headers-2.6.25.4";
  
  builder = ./builder.sh;
  
  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v2.6/linux-2.6.25.4.tar.bz2";
    sha256 = "0hp36pwphw5rs9kwm5ksr7ynfmzgpcd8gi45rigbilvcvmsdnxf3";
  };

  platform = 
    if stdenv.system == "i686-linux" then "i386" else
    if stdenv.system == "x86_64-linux" then "x86_64" else
    if stdenv.system == "powerpc-linux" then "powerpc" else
    abort "don't know what the kernel include directory is called for this platform";

  # !!! hacky
  fixupPhase = "ln -s $out/include/asm $out/include/asm-$platform";

  extraIncludeDirs =
    if stdenv.system == "powerpc-linux" then ["ppc"] else [];
}
