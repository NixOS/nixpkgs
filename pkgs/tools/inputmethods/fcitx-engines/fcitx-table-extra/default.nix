{ stdenv, fetchurl, cmake, fcitx, gettext }:

stdenv.mkDerivation rec {
  name = "fcitx-table-extra-${version}";
  version = "0.3.8";

  src = fetchurl {
    url = "http://download.fcitx-im.org/fcitx-table-extra/${name}.tar.xz";
    sha256 = "c91bb19c1a7b53c5339bf2f75ae83839020d337990f237a8b9bc0f4416c120ef";
  };

  buildInputs = [ cmake fcitx gettext ];

  preInstall = ''
   substituteInPlace tables/cmake_install.cmake \
      --replace ${fcitx} $out
  '';

  meta = with stdenv.lib; {
    isFcitxEngine = true;
    homepage      = "https://github.com/fcitx/fcitx-table-extra";
    downloadPage  = "http://download.fcitx-im.org/fcitx-table-extra/";
    description   = "Provides extra table for Fcitx, including Boshiamy, Zhengma, Cangjie, and Quick";
    license       = licenses.gpl2Plus;
    platforms     = platforms.linux;
    maintainers   = with maintainers; [ linc01n ];
  };

}
