{ lib, fetchFromGitHub, python39Packages, wrapQtAppsHook }:

let
  pname = "nagstamon";
  version = "v3.8.0";
in python39Packages.buildPythonApplication rec {
  inherit pname;
  inherit version;

  src = fetchFromGitHub {
    owner = "HenriWahl";
    repo = "Nagstamon";
    rev = "${version}";
    sha256 = "0a8aqw44z58pabsgxlvndnmzzvc50wrb4g12yp6zgajn40b2l8pw";
  };

  doCheck = false;

  nativeBuildInputs = [ wrapQtAppsHook ];
  postFixup = ''
    wrapQtApp $out/bin/nagstamon.py
  '';

  propagatedBuildInputs = with python39Packages; [
    beautifulsoup4
    configparser
    dateutil
    kerberos
    keyring
    lxml
    psutil
    pyqt5_with_qtmultimedia
    requests
    requests-kerberos
    setuptools
    xlib
  ];

  meta = with lib; {
    description = "A status monitor for the desktop";
    homepage = "https://nagstamon.ifw-dresden.de/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ foosinn ];
    inherit version;
  };
}

