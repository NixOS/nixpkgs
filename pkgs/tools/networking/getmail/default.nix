{ stdenv, fetchurl, buildPythonPackage }:

buildPythonPackage rec {
  name = "getmail-4.43.0";
  namePrefix = "";

  src = fetchurl {
    url = "http://pyropus.ca/software/getmail/old-versions/${name}.tar.gz";
    sha256 = "0abcj4d2jp9y56c85kq7265d8wcij91w9lpzib9q6j9lcs4la8hy";
  };

  doCheck = false;

  meta = {
    description = "A program for retrieving mail";
    maintainers = [ stdenv.lib.maintainers.raskin stdenv.lib.maintainers.iElectric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
