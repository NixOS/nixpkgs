{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name    = "lockdep-${version}";
  version = "3.14.2";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "0grf6hksx4gidqim05blsnvk5037y852smr8mn0hcnbwvvp1hxal";
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
