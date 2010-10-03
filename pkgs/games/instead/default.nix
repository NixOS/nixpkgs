{ stdenv, fetchurl, SDL, SDL_ttf, SDL_image, SDL_mixer, pkgconfig, lua, zlib, unzip }:

let
  version = "1.2.2";

  # I took two games at random from http://instead.syscall.ru/games/
  games = [
    (fetchurl {
      url = http://instead-games.googlecode.com/files/instead-apple-day-1.2.zip;
      sha256 = "0d4m554hiqmgl4xl0jp0b3bqjl35879768hqznh9y57y04sygd2a";
    })
    (fetchurl {
      url = http://instead-games.googlecode.com/files/instead-cat-1.3.zip;
      sha256 = "0vmsn7jg2vy5kqqbzad289vk4j3piarj1xpwyz72wgyc3k7djg4v";
    })
    (fetchurl {
      url = http://instead-games.googlecode.com/files/instead-cat_en-1.2.zip;
      sha256 = "0jlm3ssqlka16dm0rg6qfjh6xdh3pv7lj2s4ib4mqwj2vfy0v6sg";
    })
    (fetchurl {
      url = http://instead-games.googlecode.com/files/instead-vinny-0.1.zip;
      sha256 = "15qdbg82zp3a8vz4qxminr0xbzbdpnsciliy2wm3raz4hnadawg1";
    })
  ];
in

stdenv.mkDerivation rec {
  name = "instead-" + version;

  src = fetchurl {
    url = "http://instead.googlecode.com/files/instead_${version}.tar.gz";
    sha256 = "178xxqvjl5v1bhjrlf8cqpkw85j25fldf0wn6bgyzicr6fspxb25";
  };

  NIX_LDFLAGS = "-llua -lgcc_s";

  buildInputs = [ SDL SDL_ttf SDL_image SDL_mixer pkgconfig lua zlib unzip ];

  configurePhase = ''
    sed -i -e "s,DATAPATH=.,DATAPATH=$out/share/${name}/," Rules.make
  '';

  inherit games;

  installPhase = ''
    ensureDir $out/bin $out/share/${name}
    cp sdl-instead $out/bin
    cp -R games languages stead themes $out/share/${name}
    pushd $out/share/${name}/games
    for a in $games; do
      unzip $a
    done
    popd
  '';

  meta = {
    description = "Simple text adventure interpreter for Unix and Windows";
    homepage = http://instead.syscall.ru/;
    license = "GPLv2";
    platforms = with stdenv.lib.platforms; linux;
  };
}
