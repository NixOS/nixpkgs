{ stdenv, fetchurl, python2Packages }:

python2Packages.buildPythonApplication rec {
  version = "4.53.0";
  name = "getmail-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "http://pyropus.ca/software/getmail/old-versions/${name}.tar.gz";
    sha256 = "1awjdxiq3d25h10h32a7h2wxbkgvgvsnicp5xwx4p8mm6gz9c998";
  };

  doCheck = false;

  meta = {
    description = "A program for retrieving mail";
    maintainers = [ stdenv.lib.maintainers.raskin stdenv.lib.maintainers.domenkozar ];
    platforms = stdenv.lib.platforms.linux;

    homepage = "http://pyropus.ca/software/getmail/";
    inherit version;
    updateWalker = true;
  };
}
