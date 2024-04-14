{ stdenv, mkDerivation, lib, fetchurl, cmake, pkg-config, makeWrapper
, httrack, qtbase, qtmultimedia }:

mkDerivation rec {
  pname = "httraqt";
  version = "1.4.9";

  src = fetchurl {
    url = "mirror://sourceforge/httraqt/${pname}-${version}.tar.gz";
    sha256 = "0pjxqnqchpbla4xiq4rklc06484n46cpahnjy03n9rghwwcad25b";
  };

  buildInputs = [ httrack qtbase qtmultimedia ];

  nativeBuildInputs = [ cmake makeWrapper pkg-config ];

  prePatch = ''
    substituteInPlace cmake/HTTRAQTFindHttrack.cmake \
      --replace /usr/include/httrack/ ${httrack}/include/httrack/

    substituteInPlace distribution/posix/CMakeLists.txt \
      --replace /usr/share $out/share

    substituteInPlace desktop/httraqt.desktop \
      --replace Exec=httraqt Exec=$out/bin/httraqt

    substituteInPlace sources/main/httraqt.cpp \
      --replace /usr/share/httraqt/ $out/share/httraqt
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Easy-to-use offline browser / website mirroring utility - QT frontend";
    mainProgram = "httraqt";
    homepage    = "http://www.httrack.com";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
    platforms   = with platforms; unix;
  };
}
