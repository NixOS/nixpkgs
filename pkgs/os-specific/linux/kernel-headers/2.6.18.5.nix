{stdenv, fetchurl, unifdef}:

assert stdenv.isLinux;

stdenv.mkDerivation {
  name = "linux-headers-2.6.18.5";
  builder = ./builder.sh;
  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v2.6/linux-2.6.18.5.tar.bz2";
    sha256 = "24f0e0011cdae42e3dba56107bb6a60c57c46d1d688a9b0300fec53e80fd1e53";
  };

  patches = [ ./unifdef-getline.patch ];

  buildInputs = [ unifdef ];

  platform = 
    if stdenv.system == "i686-linux" then "i386" else
    if stdenv.system == "x86_64-linux" then "x86_64" else
    if stdenv.system == "powerpc-linux" then "powerpc" else
    abort "don't know what the kernel include directory is called for this platform";

  extraIncludeDirs =
    if stdenv.system == "powerpc-linux" then ["ppc"] else [];
}
