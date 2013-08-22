{ stdenv, fetchurl, SDL, SDL_ttf, SDL_image, SDL_mixer, pkgconfig, lua, zlib, unzip }:

let
  version = "1.9.1";

  # I took several games at random from http://instead.syscall.ru/games/
  games = [
    (fetchurl {
      url = http://instead-games.googlecode.com/files/instead-apple-day-1.2.zip;
      sha256 = "0d4m554hiqmgl4xl0jp0b3bqjl35879768hqznh9y57y04sygd2a";
    })
    (fetchurl {
      url = http://instead-games.googlecode.com/files/instead-cat_en-1.2.zip;
      sha256 = "0jlm3ssqlka16dm0rg6qfjh6xdh3pv7lj2s4ib4mqwj2vfy0v6sg";
    })
    (fetchurl {
      url = http://instead-games.googlecode.com/files/instead-vinny-0.1.zip;
      sha256 = "15qdbg82zp3a8vz4qxminr0xbzbdpnsciliy2wm3raz4hnadawg1";
    })
    (fetchurl {
      url = http://instead-games.googlecode.com/files/instead-toilet3in1-1.2.zip;
      sha256 = "0wz4bljbg67m84qwpaqpzs934a5pcbhpgh39fvbbbfvnnlm4lirl";
    })
    (fetchurl {
      url = http://instead-games.googlecode.com/files/instead-kayleth-0.4.1.zip;
      sha256 = "0xmn9inys0kbcdd02qaqp8gazqs67xq3fq7hvcy2qb9jbq85j8b2";
    })
  ];
in

stdenv.mkDerivation rec {
  name = "instead-" + version;

  src = fetchurl {
    url = "http://downloads.sourceforge.net/project/instead/instead/${version}/instead_${version}.tar.gz";
    sha256 = "f5577c5118b5f4a2897c7bb26f3ad7993005dbf0ae8fe762b4434e1151ddb430";
  };

  NIX_LDFLAGS = "-llua -lgcc_s";

  buildInputs = [ SDL SDL_ttf SDL_image SDL_mixer pkgconfig lua zlib unzip ];

  configurePhase = ''
    { echo 2; echo $out; } | ./configure.sh
  '';

  inherit games;

  installPhase = ''
    make install

    pushd $out/share/instead/games
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
