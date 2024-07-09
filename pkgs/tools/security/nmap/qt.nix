{ lib, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, wrapQtAppsHook
, dnsutils
, nmap
, qtbase
, qtscript
, qtwebengine
}:

stdenv.mkDerivation rec {
  pname = "nmapsi4";
  version = "0.5-alpha2";

  src = fetchFromGitHub {
    owner = "nmapsi4";
    repo = "nmapsi4";
    rev = "v${version}";
    sha256 = "sha256-q3XfwJ4TGK4E58haN0Q0xRH4GDpKD8VZzyxHe/VwBqY=";
  };

  nativeBuildInputs = [ cmake pkg-config wrapQtAppsHook ];

  buildInputs = [ qtbase qtscript qtwebengine ];

  postPatch = ''
    substituteInPlace src/platform/digmanager.cpp \
      --replace '"dig"' '"${dnsutils}/bin/dig"'
    substituteInPlace src/platform/discover.cpp \
        --replace '"nping"' '"${nmap}/bin/nping"'
    for f in \
      src/platform/monitor/monitor.cpp \
      src/platform/nsemanager.cpp ; do

      substituteInPlace $f \
        --replace '"nmap"'  '"${nmap}/bin/nmap"'
    done
  '';

  postInstall = ''
    mv $out/share/applications/kde4/*.desktop $out/share/applications
    rmdir $out/share/applications/kde4

    for f in $out/share/applications/* ; do
      substituteInPlace $f \
        --replace Qt4                   Qt5 \
        --replace Exec=nmapsi4          Exec=$out/bin/nmapsi4 \
        --replace "Exec=kdesu nmapsi4" "Exec=kdesu $out/bin/nmapsi4"
    done
  '';

  meta = with lib; {
    description = "Qt frontend for nmap";
    mainProgram = "nmapsi4";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ peterhoeg ];
    inherit (src.meta) homepage;
  };
}
