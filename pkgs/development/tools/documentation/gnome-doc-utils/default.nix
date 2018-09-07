{fetchurl, pkgconfig, libxml2Python, libxslt, intltool
, python2Packages }:

python2Packages.buildPythonApplication {
  name = "gnome-doc-utils-0.20.10";
  format = "other";

  src = fetchurl {
    url = mirror://gnome/sources/gnome-doc-utils/0.20/gnome-doc-utils-0.20.10.tar.xz;
    sha256 = "19n4x25ndzngaciiyd8dd6s2mf9gv6nv3wv27ggns2smm7zkj1nb";
  };

  nativeBuildInputs = [ intltool pkgconfig ];
  buildInputs = [ libxslt ];

  configureFlags = [ "--disable-scrollkeeper" ];

  preBuild = ''
    substituteInPlace xml2po/xml2po/Makefile --replace '-e "s+^#!.*python.*+#!$(PYTHON)+"' '-e "s\"^#!.*python.*\"#!$(PYTHON)\""'
  '';

  propagatedBuildInputs = [ libxml2Python ];
}
