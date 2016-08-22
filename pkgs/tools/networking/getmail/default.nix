{ stdenv, fetchurl, buildPythonApplication }:

buildPythonApplication rec {
  version = "4.50.0";
  name = "getmail-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "http://pyropus.ca/software/getmail/old-versions/${name}.tar.gz";
    sha256 = "1hcb5079mkcx3gglfycrhglrgg4jsa499br50yjrh9sal6wpgg7w";
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
