{ lib
, stdenv
, fetchurl
, fetchpatch
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

  patches = [
    # Pull patch pending upstream inclusion for -fno-common toolchain support:
    #   https://savannah.gnu.org/patch/index.php?10211
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://savannah.gnu.org/patch/download.php?file_id=53275";
      sha256 = "sha256-ZOo9jAy1plFjhC5HXJQvXL+Zf7FL14asV3G4AwfgqTY=";
    })
  ];

  nativeBuildInputs = [ pkg-config ];
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
