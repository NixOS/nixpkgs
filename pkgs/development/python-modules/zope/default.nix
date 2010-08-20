{stdenv, fetchurl, python}:

stdenv.mkDerivation rec {
  version = "3.4.0";
  name = "zope-${version}";
  src = fetchurl {
    url = "http://www.zope.org/Products/Zope3/${version}/Zope-${version}.tgz";
    sha256 = "3e834e8749945d8fc0a67bb724f2cf0c671f04f477e24fb8edb74828e331901d";
  };
  patches = [
    ./zope_python-2.4.4.patch
    ./zope_python-readline.patch
  ];
  buildInputs = [python];
}
