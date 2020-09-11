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
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "python-xapp";
    rev = version;
    sha256 = "1pp3z4q6ryxcc26kaq222j53ji110n2v7rx29c7vy1fbb8mq64im";
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
