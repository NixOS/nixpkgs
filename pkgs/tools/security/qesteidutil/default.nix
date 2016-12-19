{ stdenv, fetchurl, cmake, ccid, qttools, qttranslations, pkgconfig, pcsclite
, hicolor_icon_theme }:

stdenv.mkDerivation rec {

  version = "3.12.2.1206";
  name = "qesteidutil-${version}";
  
  src = fetchurl {
    url = "https://installer.id.ee/media/ubuntu/pool/main/q/qesteidutil/qesteidutil_3.12.2.1206.orig.tar.xz";
    sha256 = "1v1i0jlycjjdg6wi4cpm1il5v1zn8dfj82mrfvsjy6j9rfzinkda";
  };

  unpackPhase = ''
    mkdir src
    tar xf $src -C src
    cd src
  '';

  buildInputs = [ cmake ccid qttools pkgconfig pcsclite qttranslations
                  hicolor_icon_theme
                ];
  
  meta = with stdenv.lib; {
    description = "UI application for managing smart card PIN/PUK codes and certificates";
    homepage = "http://www.id.ee/";
    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.jagajaga ];
  };
}
