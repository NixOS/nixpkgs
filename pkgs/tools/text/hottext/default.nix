{ lib, nimPackages, fetchurl, gentium, makeDesktopItem }:

nimPackages.buildNimPackage rec {
  pname = "hottext";
  version = "1.4";

  nimBinOnly = true;

  src = fetchurl {
    url = "https://git.sr.ht/~ehmry/hottext/archive/v${version}.tar.gz";
    sha256 = "sha256-hIUofi81zowSMbt1lUsxCnVzfJGN3FEiTtN8CEFpwzY=";
  };

  buildInputs = with nimPackages; [
    pixie
    sdl2
  ];

  HOTTEXT_FONT_PATH = "${gentium}/share/fonts/truetype/GentiumPlus-Regular.ttf";

  desktopItem = makeDesktopItem {
    categories = [ "Utility" ];
    comment = meta.description;
    desktopName = pname;
    exec = pname;
    name = pname;
  };

  postInstall = ''
    cp -r $desktopItem/* $out
  '';

  meta = with lib; {
    broken = true; # Needs to be updated to latest Pixie API.
    description = "Simple RSVP speed-reading utility";
    license = licenses.unlicense;
    homepage = "https://git.sr.ht/~ehmry/hottext";
    maintainers = with maintainers; [ ehmry ];
  };
}
