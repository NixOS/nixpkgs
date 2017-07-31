{ stdenv, fetchurl, cmake, ccid, qttools, qttranslations, pkgconfig, pcsclite
, hicolor_icon_theme }:

stdenv.mkDerivation rec {

  version = "3.12.5.1233";
  name = "qesteidutil-${version}";
  
  src = fetchurl {
    url = "https://installer.id.ee/media/ubuntu/pool/main/q/qesteidutil/qesteidutil_${version}.orig.tar.xz";
    sha256 = "b5f0361af1891cfab6f9113d6b2fab677cc4772fc18b62df7d6e997f13b97857";
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
