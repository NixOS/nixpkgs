args: with args;
stdenv.mkDerivation {
  name = "ndiswrapper-1.49-stable";

  # need at least .config and include 
  inherit kernel;

  buildPhase = "
    make KBUILD=\$kernel/lib/modules/*/build;
  ";

  # should we use unstable? 
  src = args.fetchurl {
    url = http://kent.dl.sourceforge.net/sourceforge/ndiswrapper/ndiswrapper-1.49.tar.gz;
    sha256 = "1b9nqkk7gv6gffzj9b8mjy5myxf2afwpyr2n5wbfsylf15dvvvjr";
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
