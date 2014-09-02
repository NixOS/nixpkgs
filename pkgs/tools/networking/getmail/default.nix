{ stdenv, fetchurl, buildPythonPackage }:

buildPythonPackage rec {
  version = "4.46.0";
  name = "getmail-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "http://pyropus.ca/software/getmail/old-versions/${name}.tar.gz";
    sha256 = "15rqmm25pq6ll8aaqh8h6pfdkpqs7y6yismb3h3w1bz8j292c8zl";
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
