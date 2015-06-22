{ stdenv, fetchurl, buildPythonPackage }:

buildPythonPackage rec {
  version = "4.48.0";
  name = "getmail-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "http://pyropus.ca/software/getmail/old-versions/${name}.tar.gz";
    sha256 = "0k5rm5kag14izng2ajcagvli9sns5mzvkyfa65ri4xymxs91wi29";
  };

  doCheck = false;

  meta = {
    description = "A program for retrieving mail";
    maintainers = [ stdenv.lib.maintainers.raskin stdenv.lib.maintainers.iElectric ];
    platforms = stdenv.lib.platforms.linux;

    homepage = "http://pyropus.ca/software/getmail/";
    inherit version;
    updateWalker = true;
  };
}
