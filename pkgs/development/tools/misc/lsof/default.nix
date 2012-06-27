{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "lsof-4.86";

  src = fetchurl {
    url = ftp://lsof.itap.purdue.edu/pub/tools/unix/lsof/lsof_4.86.tar.bz2;
    sha256 = "13e52b8e87dddf1b2e219004e315d755c659217ce6ffc6a5f1102969f1c4dd0c";
  };

  unpackPhase = "tar xvjf $src; cd lsof_*; tar xvf lsof_*.tar; sourceRoot=$( echo lsof_*/); ";
  
  preBuild = "sed -i Makefile -e 's/^CFGF=/&	-DHASIPv6=1/;';";
  
  configurePhase = "./Configure -n linux;";
  
  installPhase = ''
    mkdir -p $out/bin $out/man/man8
    cp lsof.8 $out/man/man8/
    cp lsof $out/bin
  '';

  meta = {
    homepage = ftp://lsof.itap.purdue.edu/pub/tools/unix/lsof/;
    description = "A tool to list open files";
    longDescription = ''
      List open files. Can show what process has opened some file,
      socket (IPv6/IPv4/UNIX local), or partition (by opening a file
      from it).
    '';
  };
}
