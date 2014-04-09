{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name    = "lockdep-${version}";
  version = "3.14";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "61558aa490855f42b6340d1a1596be47454909629327c49a5e4e10268065dffa";
  };

  preConfigure = "cd tools/lib/lockdep";
  installPhase = ''
    mkdir -p $out/bin $out/lib $out/include

    cp -R include/liblockdep $out/include
    make install DESTDIR=$out prefix=""

    substituteInPlace $out/bin/lockdep --replace "./liblockdep.so" "$out/lib/liblockdep.so"
  '';

  meta = {
    description = "userspace locking validation tool built on the Linux kernel";
    homepage    = "https://kernel.org/";
    license     = stdenv.lib.licenses.gpl2;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
