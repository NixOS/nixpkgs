{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "lsof-${version}";
  version = "4.89";

  src = fetchurl {
    url = "ftp://sunsite.ualberta.ca/pub/Mirror/lsof/lsof_${version}.tar.bz2";
    sha256 = "061p18v0mhzq517791xkjs8a5dfynq1418a1mwxpji69zp2jzb41";
  };

  unpackPhase = "tar xvjf $src; cd lsof_*; tar xvf lsof_*.tar; sourceRoot=$( echo lsof_*/); ";
  
  preBuild = "sed -i Makefile -e 's/^CFGF=/&	-DHASIPv6=1/;';";
  
  configurePhase = if stdenv.isDarwin
    then "./Configure -n darwin;"
    else "./Configure -n linux;";
  
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
    maintainers = [ stdenv.lib.maintainers.mornfall ];
  };
}
