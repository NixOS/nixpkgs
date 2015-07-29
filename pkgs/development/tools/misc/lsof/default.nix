{stdenv, fetchurl}:
let
  version = "4.87";
in
stdenv.mkDerivation {
  name = "lsof-${version}";

  src = fetchurl {
    urls = map (
      # the tarball is moved after new version is released
      isOld: "ftp://sunsite.ualberta.ca/pub/Mirror/lsof/"
      + "${stdenv.lib.optionalString isOld "OLD/"}lsof_${version}.tar.bz2"
    ) [ false true ];
    sha256 = "0b6si72sml7gr9784ak491cxxbm9mx5bh174yg6rrirbv04kgpfz";
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
