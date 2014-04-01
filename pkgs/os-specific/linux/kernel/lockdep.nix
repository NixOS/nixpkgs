{ stdenv, kernel }:

assert stdenv.lib.versionAtLeast kernel.version "3.14";
stdenv.mkDerivation {
  name = "lockdep-linux-${kernel.version}";
  inherit (kernel) src patches;

  preConfigure = "cd tools/lib/lockdep";
  installPhase = ''
    mkdir -p $out/bin $out/lib $out/include

    cp -R include/liblockdep $out/include
    make install DESTDIR=$out prefix=""

    substituteInPlace $out/bin/lockdep --replace "./liblockdep.so" "$out/lib/liblockdep.so"
  '';

  meta = {
    description = "User-space locking validation via the kernel";
    homepage    = "https://kernel.org/";
    license     = stdenv.lib.licenses.gpl2;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
