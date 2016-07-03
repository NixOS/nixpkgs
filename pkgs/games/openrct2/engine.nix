{ stdenv, fetchurl, cmake, pkgconfig
, SDL2, SDL2_ttf, fontconfig, jansson, speexdsp, openssl, curl }:

let
  originalExecutable = "setup_rollercoaster_tycoon_2.exe";
in
  stdenv.mkDerivation rec {
    name = "openrct2-engine-${version}";
    version = "0.0.4";

    meta = {
      description = ''An open source re-implementation of Roller Coaster Tycoon 2'';
      longDescription = ''
        OpenRCT2 is an open-source re-implementation of RollerCoaster
        Tycoon 2 (RCT2). The gameplay revolves around building and
        maintaining an amusement park containing attractions, shops
        and facilities. The player must try to make a profit and
        maintain a good park reputation whilst keeping the guests
        happy. OpenRCT2 allows for both scenario and sandbox play.

        Scenarios require the player to complete a certain objective
        in a set time limit whilst sandbox allows the player to build
        a more flexible park with optionally no restrictions or
        finance.
      '';
      homepage = http://www.openrct2.website/;
      license = stdenv.lib.licenses.gpl3;
      platforms = stdenv.lib.platforms.linux;
      maintainers = with stdenv.lib.maintainers; [ joepie91 ];
    };

    src = fetchurl {
      url = "https://github.com/OpenRCT2/OpenRCT2/archive/v${version}.tar.gz";
      sha256 = "1as0xf6zjxsjawllkjhbfdnaw7r78n8fq22kadl63dycwcfvzjzb";
    };

    buildInputs = [
      cmake pkgconfig
      SDL2 SDL2_ttf fontconfig jansson speexdsp openssl curl
    ];
  }