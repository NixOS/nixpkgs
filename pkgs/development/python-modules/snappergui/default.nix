{ stdenv
, buildPythonPackage
, fetchgit
, pygobject3
, dbus-python
}:

buildPythonPackage rec {
  pname = "Snapper-GUI";
  version = "0.1";

  src = fetchgit {
    url = "https://github.com/ricardomv/snapper-gui";
    rev = "11d98586b122180c75a86fccda45c4d7e3137591";
    sha256 = "7a9f86fc17dbf130526e70c3e925eac30e2c74d6b932efbf7e7cd9fbba6dc4b1";
  };

  # no tests available
  doCheck = false;

  propagatedBuildInputs = [ pygobject3 dbus-python ];

  meta = with stdenv.lib; {
    homepage = https://github.com/ricardomv/snapper-gui;
    description = "Graphical frontend for snapper";
    license = licenses.gpl2;
    maintainers = with maintainers; [ tstrobel ];
  };

}
