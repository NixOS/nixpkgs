{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name    = "lockdep-${version}";
  version = "4.1.2";
  fullver = "4.1.2";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1mdyjhnzhh254cblahqmpsk226z006z6sm9dmwvg6jlhpsw4cjhy";
  };

  preConfigure = "cd tools/lib/lockdep";
  installPhase = ''
    mkdir -p $out/bin $out/lib $out/include

    cp -R include/liblockdep $out/include
    make install DESTDIR=$out prefix=""

    substituteInPlace $out/bin/lockdep --replace "./liblockdep.so" "$out/lib/liblockdep.so.$fullver"
  '';

  meta = {
    description = "Userspace locking validation tool built on the Linux kernel";
    homepage    = "https://kernel.org/";
    license     = stdenv.lib.licenses.gpl2;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
