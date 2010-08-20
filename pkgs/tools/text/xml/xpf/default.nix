{stdenv, fetchurl, python, libxml2}:

assert libxml2.pythonSupport == true;

stdenv.mkDerivation {
  name = "xpf-0.2";
  
  src = fetchurl {
    url = http://nixos.org/tarballs/xpf-0.2.tar.gz;
    md5 = "d92658828139e1495e052d0cfe25d312";
  };
  
  buildInputs = [python libxml2];

  meta = {
    description = "XML Pipes and Filters - command line tools for manipulating and querying XML data";
    homepage = http://www.cs.uu.nl/wiki/bin/view/Martin/XmlPipesAndFilters;
  };
}
