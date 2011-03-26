{ stdenv, fetchgit, fetchgitrevision, cmake, kdelibs, automoc4, networkmanager, kdebase_workspace
, repository ? "git://anongit.kde.org/networkmanagement"
, branch ? "heads/master"
, rev ? fetchgitrevision repository branch
, src ? fetchgit {
    url = repository;
    rev = rev;
  }
}:

stdenv.mkDerivation rec {
  name = "knetwork-manager-${version}";
  version = "live";

  inherit src;  

  buildInputs = [
    cmake kdelibs automoc4 networkmanager kdebase_workspace
  ];

  meta = with stdenv.lib; {
    homepage = http://kde.org;
    description = "KDE systray and plasma applet for network management.";
    license = licenses.gpl2;
    maintainers = with maintainers; [  phreedom ];
  };
}
