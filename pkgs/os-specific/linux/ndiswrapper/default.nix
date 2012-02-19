{ stdenv, fetchurl, kernel, perl }:

stdenv.mkDerivation {
  name = "ndiswrapper-1.56-${kernel.version}";

  # need at least .config and include 
  inherit kernel;

  buildPhase = "
    echo make KBUILD=$(echo \$kernel/lib/modules/*/build);
    echo -n $kernel/lib/modules/*/build > kbuild_path
    make KBUILD=$(echo \$kernel/lib/modules/*/build);
  ";

  installPhase = ''
    make install KBUILD=$(cat kbuild_path) DESTDIR=$out
    mv $out/usr/sbin/* $out/sbin/
    mv $out/usr/share $out/
    rm -r $out/usr

    patchShebangs $out/sbin
  '';

  # should we use unstable? 
  src = fetchurl {
    url = http://downloads.sourceforge.net/ndiswrapper/ndiswrapper-1.56.tar.gz;
    sha256 = "10yqg1a08v6z1qm1qr1v4rbhl35c90gzrazapr09vp372hky8f57";
  };

  buildInputs = [ kernel perl ];

  # this is a patch against svn head, not stable version
  patches = [./prefix.patch];

  meta = { 
    description = "Ndis driver wrapper for the Linux kernel";
    homepage = http://sourceforge.net/projects/ndiswrapper;
    license = "GPL";
  };
}
