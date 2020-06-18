{ stdenv, fetchFromGitHub, cmake, pkgconfig, SDL2, gtk3, libpcap, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "melonDS";
  version = "0.8.3";
  ## When updating to the release after 0.8.3,
  ##  - Uncomment:
  ##      cmakeFlags = [ "-UUNIX_PORTABLE" ];
  ##  - Remove the postInstall, since cmake should then take care of installing icons, .desktop file, and romlist.bin
  ##    (see https://github.com/Arisotura/melonDS/pull/546)

  src = fetchFromGitHub {
    owner = "Arisotura";
    repo = pname;
    rev = version;
    sha256 = "1lqmfwjpkdqfkns1aaxlp4yrg6i0r66mxfr4rrj7b5286k44hqwn";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ cmake pkgconfig wrapGAppsHook ];
  buildInputs = [ SDL2 gtk3 libpcap ];

  postInstall = ''
    install -Dm644 -t $out/share/melonDS/ ../romlist.bin
    install -Dm644 -t $out/share/applications/ ../flatpak/*.desktop

    for i in ../icon/melon_*.png; do
      d="''${i##*_}"
      d="$out/share/icons/hicolor/''${d%.png}/apps"
      install -D $i "$d/net.kuribo64.melonds.png"
    done
  '';

  meta = with stdenv.lib; {
    homepage = "http://melonds.kuribo64.net/";
    description = "Work in progress Nintendo DS emulator";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ artemist benley ];
    platforms = platforms.linux;
  };
}
