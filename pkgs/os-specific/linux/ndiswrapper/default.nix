args: with args;
stdenv.mkDerivation {
  name = "ndiswrapper-1.53-stable";

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
  '';

  # should we use unstable? 
  src = args.fetchurl {
    url = http://downloads.sourceforge.net/ndiswrapper/ndiswrapper-1.53.tar.gz;
    sha256 = "00622nxa3q9n8v7qdz274d0nzz9r13lx77xi27s5bnk0mkila03q";
  };

  buildInputs =[kernel];

  # this is a patch against svn head, not stable version
  patches = [./prefix.patch];

  meta = { 
      description = "Ndis driver wrapper for the Linux kernel";
      homepage = http://sourceforge.net/projects/ndiswrapper;
      license = "GPL";
  };
}
