{stdenv, fetchurl, pkgconfig, libxml2Python, libxslt, intltool
, makeWrapper, python2Packages }:

python2Packages.buildPythonApplication {
  name = "gnome-doc-utils-0.20.10";
  format = "other";

  src = fetchurl {
    url = mirror://gnome/sources/gnome-doc-utils/0.20/gnome-doc-utils-0.20.10.tar.xz;
    sha256 = "19n4x25ndzngaciiyd8dd6s2mf9gv6nv3wv27ggns2smm7zkj1nb";
  };

  configureFlags = "--disable-scrollkeeper";
  buildInputs = [ libxslt pkgconfig intltool ];
  propagatedBuildInputs = [ libxml2Python ];
}
