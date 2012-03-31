{stdenv, fetchurl, python, pkgconfig, libxml2Python, libxslt, intltool
, makeWrapper, pythonPackages }:

stdenv.mkDerivation {
  name = "gnome-doc-utils-0.20.7";

  src = fetchurl {
    url = mirror://gnome/sources/gnome-doc-utils/0.20/gnome-doc-utils-0.20.7.tar.xz;
    sha256 = "01lcq6gm4q9awvg7lccq43qh8g4ibz49s2mgykin78mgph9h396q";
  };

  configureFlags = "--disable-scrollkeeper";
  buildInputs = [ python libxml2Python libxslt ];
  pythonPath = [ libxml2Python ];
  postInstall = "wrapPythonPrograms";

  buildNativeInputs = [ pkgconfig intltool pythonPackages.wrapPython ];
}
