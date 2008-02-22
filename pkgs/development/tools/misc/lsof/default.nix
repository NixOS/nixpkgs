
{stdenv, fetchurl}:
stdenv.mkDerivation {
  name = "lsof-4.78";

  src = fetchurl {
    url =ftp://sunsite.ualberta.ca/pub/Mirror/lsof/lsof_4.78.tar.bz2;
    sha256 = "0azvl43niqkq94drx52p6dvp70r38f25fqw181ywmvqn80dbb3c9";
  };

  unpackPhase = "tar xvjf $src; cd lsof_*; tar xvf lsof_*.tar; sourceRoot=$( echo lsof_*/); ";
  preBuild = "sed -i Makefile -e 's/^CFGF=/&	-DHASIPv6=1/;';";
  configurePhase = "./Configure -n linux;";
  installPhase = " mkdir -p $out/bin $out/man/man8; cp lsof.8 $out/man/man8/; cp lsof $out/bin";

  meta = {
    description = "List open files. Can show what process has opened some file, 
socket (IPv6/IPv4/UNIX local), or partition (by opening a file from it).";
  };
}
