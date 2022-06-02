{ lib
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
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "python-xapp";
    rev = version;
    hash = "sha256-UC+0nbf+SRQsF5R0LcrPpmNbaoRM14DC82JccSpsKsY=";
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

  doCheck = false;
  pythonImportsCheck = [ "xapp" ];

  meta = with lib; {
    homepage = "https://github.com/linuxmint/python-xapp";
    description = "Cross-desktop libraries and common resources for python";
    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.mkg20001 ];
  };
}
