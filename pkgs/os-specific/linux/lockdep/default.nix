{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name    = "lockdep-${version}";
  version = "3.17";
  fullver = "3.17.0"; # The library ver is 3.17.0, but the kernel is 3.17

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "0lb2yyh3j932789jq4gxx9xshgy6rfdnl3lm8yr43kaz7k4kw5gm";
  };

  preConfigure = "cd tools/lib/lockdep";
  installPhase = ''
    mkdir -p $out/bin $out/lib $out/include

    cp -R include/liblockdep $out/include
    make install DESTDIR=$out prefix=""

    substituteInPlace $out/bin/lockdep --replace "./liblockdep.so" "$out/lib/liblockdep.so.$fullver"
  '';

  meta = {
    description = "userspace locking validation tool built on the Linux kernel";
    homepage    = "https://kernel.org/";
    license     = stdenv.lib.licenses.gpl2;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
