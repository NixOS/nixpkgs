{ stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  pkgconfig,
  psutil,
  pygobject3,
  gtk3,
  gobject-introspection,
  cinnamon }:

buildPythonPackage rec {
  pname = "python-xapp";
  version = "1.8.1";
  # format = "setup";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    sha256 = "0vw3cn09nx75lv4d9idp5fdhd81xs279zhbyyilynq29cxxs2zil";
  };

  propagatedBuildInputs = [
    psutil
    pygobject3
    gtk3
    gobject-introspection
    cinnamon.xapps
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/linuxmint/python-xapp";
    description = "Cross-desktop libraries and common resources for python";

    platforms = platforms.linux;
    maintainers = [ maintainers.mkg20001 ];
  };
}
