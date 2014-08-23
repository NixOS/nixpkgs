{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name    = "lockdep-${version}";
  version = "3.16.1";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "0wbxqlmk7w9047ir51dsz6vi7ww0hpycgrb43mk2a189xaldsdxy";
  };

  preConfigure = "cd tools/lib/lockdep";
  installPhase = ''
    mkdir -p $out/bin $out/lib $out/include

    cp -R include/liblockdep $out/include
    make install DESTDIR=$out prefix=""

    substituteInPlace $out/bin/lockdep --replace "./liblockdep.so" "$out/lib/liblockdep.so.$version"
  '';

  meta = {
    description = "userspace locking validation tool built on the Linux kernel";
    homepage    = "https://kernel.org/";
    license     = stdenv.lib.licenses.gpl2;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
