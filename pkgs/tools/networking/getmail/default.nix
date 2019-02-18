{ stdenv, fetchurl, python2Packages }:

python2Packages.buildPythonApplication rec {
  pname = "getmail";
  version = "5.10";

  src = fetchurl {
    url = "http://pyropus.ca/software/getmail/old-versions/${pname}-${version}.tar.gz";
    sha256 = "0qc4gp66mhaxyjj7pfz9v69kxnw76my4zw07hvc4f3kj3balkygx";
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
