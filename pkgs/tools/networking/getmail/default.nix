{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  version = "4.51.0";
  name = "getmail-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "http://pyropus.ca/software/getmail/old-versions/${name}.tar.gz";
    sha256 = "1nzdjm62lrg7qbh8xz2irj9wxf2861s3ld6zd5fbcgpjy3v588mw";
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
