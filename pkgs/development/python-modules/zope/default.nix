{stdenv, fetchurl, python}:

stdenv.mkDerivation rec {
	version = "3.2.1";
  name = "zope-${version}";
  src = fetchurl {
	  url = "http://www.zope.org/Products/Zope3/${version}/Zope-${version}.tgz";
    sha256 = "8431984af75054e4ddfe45bf708924240f8b6b02220cd84d090138413ac82341";
  };
  patches = [
    ./zope_python-2.4.4.patch
    ./zope_python-readline.patch
  ];
  buildInputs = [python];
}
