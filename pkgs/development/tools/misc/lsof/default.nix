{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "lsof-4.85";

  src = fetchurl {
    url = ftp://lsof.itap.purdue.edu/pub/tools/unix/lsof/lsof_4.85.tar.bz2;
    sha256 = "1hd1aihbzx2c2p4ps4zll6nldyf9l7js59hllnnmpi1r6pk5iaj9";
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
