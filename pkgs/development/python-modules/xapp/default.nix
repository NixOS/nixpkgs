{ stdenv
, fetchFromGitHub
, buildPythonPackage
, psutil
, pygobject3
, gtk3
, gobject-introspection
, xapps
, polkit
}:

buildPythonPackage rec {
  pname = "xapp";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "python-xapp";
    rev = version;
    sha256 = "0vw3cn09nx75lv4d9idp5fdhd81xs279zhbyyilynq29cxxs2zil";
  };

  propagatedBuildInputs = [
    psutil
    pygobject3
    gtk3
    gobject-introspection
    xapps
    polkit
  ];

  postPatch = ''
    substituteInPlace "xapp/os.py" --replace "/usr/bin/pkexec" "${polkit}/bin/pkexec"
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/linuxmint/python-xapp";
    description = "Cross-desktop libraries and common resources for python";
    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.mkg20001 ];
  };
}
