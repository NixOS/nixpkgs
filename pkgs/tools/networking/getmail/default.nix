{ stdenv, fetchurl, python2Packages }:

python2Packages.buildPythonApplication rec {
  version = "5.6";
  name = "getmail-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "http://pyropus.ca/software/getmail/old-versions/${name}.tar.gz";
    sha256 = "16nmvj80szr6yvcxxgmxn2lxqpjqqj4xg5a0b66zhvck6j42q3a6";
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
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
