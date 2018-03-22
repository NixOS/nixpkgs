{ stdenv, fetchurl, python2Packages }:

python2Packages.buildPythonApplication rec {
  version = "5.5";
  name = "getmail-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "http://pyropus.ca/software/getmail/old-versions/${name}.tar.gz";
    sha256 = "0l43lbnrnyyrq8mlnw37saq6v0mh3nkirdq1dwnsrihykzjjwf70";
  };

  doCheck = false;

  postPatch = ''
    # getmail spends a lot of effort to build an absolute path for
    # documentation installation; too bad it is counterproductive now
    sed -e '/datadir or prefix,/d' -i setup.py
  '';

  meta = {
    description = "A program for retrieving mail";
    maintainers = [ stdenv.lib.maintainers.raskin stdenv.lib.maintainers.domenkozar ];
    platforms = stdenv.lib.platforms.linux;

    homepage = http://pyropus.ca/software/getmail/;
    inherit version;
    updateWalker = true;
  };
}
