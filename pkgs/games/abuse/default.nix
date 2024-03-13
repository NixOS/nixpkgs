{ lib, stdenv, fetchzip, fetchFromGitHub
, makeDesktopItem, copyDesktopItems
, cmake
, SDL2, SDL2_mixer, freepats
}:

stdenv.mkDerivation rec {
  pname   = "abuse";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "Xenoveritas";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-eneu0HxEoM//Ju2XMHnDMZ/igeVMPSLg7IaxR2cnJrk=";
  };

  data = fetchzip {
    url  = "http://abuse.zoy.org/raw-attachment/wiki/download/abuse-0.8.tar.gz";
    hash = "sha256-SOrtBNLWskN7Tqa0B3+KjlZlqPjC64Jp02Pk7to2hFg=";
  };

  preConfigure = ''
    cp --reflink=auto -r ${data}/data/sfx ${data}/data/music data/
  '';

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

    install -Dm644 ${data}/doc/abuse.png $out/share/pixmaps/abuse.png
  '';

  env.NIX_CFLAGS_COMPILE = "-I${lib.getDev SDL2}/include/SDL2";

  nativeBuildInputs = [ copyDesktopItems cmake ];
  buildInputs       = [ SDL2 SDL2_mixer freepats ];

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
