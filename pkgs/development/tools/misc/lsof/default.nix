
{stdenv, fetchurl}:
stdenv.mkDerivation {
  name = "lsof";

  src = fetchurl {
    url = ftp://lsof.itap.purdue.edu/pub/tools/unix/lsof/lsof_4.78.tar.bz2;
    sha256 = "0azvl43niqkq94drx52p6dvp70r38f25fqw181ywmvqn80dbb3c9";
  };

  unpackPhase = "tar xvjf $src; cd lsof_*; tar xvf lsof_*.tar; sourceRoot=lsof_*; ";
  configurePhase = "./Configure -n linux;";
  preBuild = "sed -i Makefile -e 's/^CFGF=/&	-DHASIPv6=1/;';";
  installPhase = " mkdir -p $out/bin $out/man/man8; cp lsof.8 $out/man/man8/; cp lsof $out/bin";
}
