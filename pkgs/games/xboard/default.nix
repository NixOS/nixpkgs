{ lib
, stdenv
, fetchurl
, libX11
, xorgproto
, libXt
, libXaw
, libSM
, libICE
, libXmu
, libXext
, gnuchess
, texinfo
, libXpm
, pkg-config
, librsvg
, cairo
, pango
, gtk2
}:

stdenv.mkDerivation rec {
  pname = "xboard";
  version = "4.9.1";

  src = fetchurl {
    url = "mirror://gnu/xboard/xboard-${version}.tar.gz";
    sha256 = "sha256-Ky5T6EKK2bbo3IpVs6UYM4GRGk2uLABy+pYpa7sZcNY=";
  };

  buildInputs = [
    libX11
    xorgproto
    libXt
    libXaw
    libSM
    libICE
    libXmu
    libXext
    gnuchess
    texinfo
    libXpm
    pkg-config
    librsvg
    cairo
    pango
    gtk2
  ];

  meta = with lib; {
    description = "GUI for chess engines";
    homepage = "https://www.gnu.org/software/xboard/";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
  };
}
