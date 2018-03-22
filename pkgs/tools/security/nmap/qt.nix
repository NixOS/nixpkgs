{ stdenv, fetchurl, cmake, pkgconfig, makeWrapper
, dnsutils, nmap
, qtbase, qtscript, qtwebkit }:

stdenv.mkDerivation rec {
  name = "nmapsi4-${version}";
  version = "0.5-alpha1";

  src = fetchurl {
    url = "mirror://sourceforge/nmapsi/${name}.tar.xz";
    sha256 = "18v9a3l2nmij3gb4flscigxr5c44nphkjfmk07qpyy73fy61mzrs";
  };

  nativeBuildInputs = [ cmake makeWrapper pkgconfig ];

  buildInputs = [ qtbase qtscript qtwebkit ];

  enableParallelBuilding = true;

  postPatch = ''
    for f in \
      src/platform/digmanager.cpp \
      src/platform/discover.cpp \
      src/platform/monitor/monitor.cpp \
      src/platform/nsemanager.cpp ; do

      substituteInPlace $f \
        --replace '"dig"'   '"${dnsutils}/bin/dig"'\
        --replace '"nmap"'  '"${nmap}/bin/nmap"' \
        --replace '"nping"' '"${nmap}/bin/nping"'
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
    homepage    = https://www.nmapsi4.org/;
    license     = licenses.gpl2;
    platforms   = platforms.all;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
