{ lib
, fetchFromGitHub
, buildPythonPackage
, psutil
, pygobject3
, gtk3
, gobject-introspection
, xapp
, polkit
}:

buildPythonPackage rec {
  pname = "xapp";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "python-xapp";
    rev = version;
    hash = "sha256-ntjJ/O6HiRZMsqsuQY4HLM4fBE0aWpn/L4n5YCRlhhg=";
  };

  propagatedBuildInputs = [
    psutil
    pygobject3
    gtk3
    gobject-introspection
    xapp
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
    maintainers = teams.cinnamon.members;
  };
}
