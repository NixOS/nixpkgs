{ stdenv, fetchFromGitHub, cmake, pkgconfig, wrapQtAppsHook
, dnsutils, nmap
, qtbase, qtscript, qtwebengine }:

stdenv.mkDerivation rec {
  pname = "nmapsi4";
  version = "0.4.80-20180430";

  src = fetchFromGitHub {
    owner = "nmapsi4";
    repo = "nmapsi4";
    rev = "d7f18e4c1e38dcf9c29cb4496fe14f9ff172861a";
    sha256 = "10wqyrjzmad1g7lqa65rymbkna028xbp4xcpj442skw8gyrs3994";
  };

  nativeBuildInputs = [ cmake pkgconfig wrapQtAppsHook ];

  buildInputs = [ qtbase qtscript qtwebengine ];

  enableParallelBuilding = true;

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

  meta = with stdenv.lib; {
    description = "Qt frontend for nmap";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ peterhoeg ];
    inherit (src.meta) homepage;
  };
}
