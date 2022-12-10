{ lib, stdenv, fetchurl, makeDesktopItem, copyDesktopItems, SDL, SDL_mixer, freepats }:

stdenv.mkDerivation rec {
  pname   = "abuse";
  version = "0.8";

  src = fetchurl {
    url    = "http://abuse.zoy.org/raw-attachment/wiki/download/${pname}-${version}.tar.gz";
    sha256 = "0104db5fd2695c9518583783f7aaa7e5c0355e27c5a803840a05aef97f9d3488";
  };

  configureFlags = [
    "--with-x"
    "--with-assetdir=$(out)/orig"
    # The "--enable-debug" is to work around a segfault on start, see https://bugs.archlinux.org/task/52915.
    "--enable-debug"
  ];

  desktopItems = [ (makeDesktopItem {
    name = "abuse";
    exec = "abuse";
    icon = "abuse";
    desktopName = "Abuse";
    comment     = "Side-scroller action game that pits you against ruthless alien killers";
    categories  = [ "Game" "ActionGame" ];
  }) ];

  postInstall = ''
    mkdir $out/etc
    echo -e "dir ${freepats}\nsource ${freepats}/freepats.cfg" > $out/etc/timidity.cfg

    mv $out/bin/abuse $out/bin/.abuse-bin
    substituteAll "${./abuse.sh}" $out/bin/abuse
    chmod +x $out/bin/abuse

    install -Dm644 doc/abuse.png $out/share/pixmaps/abuse.png
  '';

  nativeBuildInputs = [ copyDesktopItems ];
  buildInputs       = [ SDL SDL_mixer freepats ];

  meta = with lib; {
    description = "Side-scroller action game that pits you against ruthless alien killers";
    homepage    = "http://abuse.zoy.org/";
    license     = with licenses; [ unfree ];
    # Most of abuse is free (public domain, GPL2+, WTFPL), however the creator
    # of its sfx and music only gave Debian permission to redistribute the
    # files. Our friends from Debian thought about it some more:
    # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=648272
    maintainers = with maintainers; [ iblech ];
    platforms   = platforms.unix;
    broken      = stdenv.isDarwin;
  };
}
