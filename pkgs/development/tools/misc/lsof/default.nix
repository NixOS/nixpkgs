{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "lsof-4.81";

  src = fetchurl {
    urls = [
      http://ftp.uni-bayreuth.de/packages/tools/lsof/lsof_4.81.tar.bz2
      ftp://lsof.itap.purdue.edu/pub/tools/unix/lsof/lsof_4.81.tar.bz2
      ftp://lsof.itap.purdue.edu/pub/tools/unix/lsof/OLD/lsof_4.81.tar.bz2
    ];
    sha256 = "1fcamd8qpczgb3kz9b2rhflbq6lyd3lic4i7xl7n99fx76ha1n19";
  };

  unpackPhase = "tar xvjf $src; cd lsof_*; tar xvf lsof_*.tar; sourceRoot=$( echo lsof_*/); ";
  
  preBuild = "sed -i Makefile -e 's/^CFGF=/&	-DHASIPv6=1/;';";
  
  configurePhase = "./Configure -n linux;";
  
  installPhase = ''
    ensureDir $out/bin $out/man/man8
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
