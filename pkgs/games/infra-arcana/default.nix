{ stdenv, fetchFromGitLab, cmake, makeWrapper, makeDesktopItem, graphicsmagick,
  SDL2, SDL2_image, SDL2_mixer }:

stdenv.mkDerivation rec {
  name = "infra-arcana-${version}";
  version = "unstable-2019-04-22";

  src = fetchFromGitLab {
    owner = "martin-tornqvist";
    repo = "ia";
    rev = "38f192f1d5b3d20739074c35b5b2a70d997ea3a0";
    sha256 = "0qgcvcpwv5mpiiq0p2881282pk3k10cmhnidbwrrsa2h9mrr2d5y";
  };

  nativeBuildInputs = [ cmake makeWrapper graphicsmagick ];

  buildInputs = [ SDL2 SDL2_image SDL2_mixer ];

  NIX_CFLAGS_COMPILE="-Wno-error=unused-value";

  desktopItem = makeDesktopItem {
    name = "infra-arcana";
    desktopName = "Infra Arcana";
    genericName = "Infra Arcana";
    comment = meta.description;
    icon = "infra-arcana";
    exec = "infra-arcana";
    categories = "Game;AdventureGame;";
    extraEntries = ''
      StartupWMClass=.ia-wrapped
    '';
  };

  postPatch = ''
    # Set release date
    substituteInPlace src/version.cpp --replace __DATE__ "\"Apr 22 2019\""
  '';

  postInstall = ''
    mkdir $out/opt $out/bin
    cp -r target/ia $out/opt
    wrapProgram $out/opt/ia/ia --run "cd $out/opt/ia"
    ln -s $out/opt/ia/ia $out/bin/infra-arcana

    # Set release version
    echo ${builtins.substring 0 8 src.rev} > $out/opt/ia/data/git-sha1.txt

    # Extract PNG icons from included ICO file
    i=0; for s in 16 32 48 64 128 256; do
      iconPath=$out/share/icons/hicolor/$s"x"$s/apps
      mkdir -p $iconPath
      gm convert -transparent white ../icon/icon.ico\[$i\] \
        $iconPath/infra-arcana.png
      i=$((i+1))
    done

    install -m 444 -D ${desktopItem}/share/applications/infra-arcana.desktop \
      $out/share/applications/infra-arcana.desktop
  '';

  meta = with stdenv.lib; {
    description = "A Roguelike set in the early 20th century";
    homepage = "https://gitlab.com/martin-tornqvist/ia/";
    longDescription = ''
      Infra Arcana is a Roguelike set in the early 20th century. The goal is
      to explore the lair of a dreaded cult called The Church of Starry Wisdom.
      Buried deep beneath their hallowed grounds lies an artifact called The
      Shining Trapezohedron - a window to all secrets of the universe. Your
      ultimate goal is to unearth this artifact.
    '';
    platforms = platforms.linux;
    license = licenses.agpl3Plus;
    maintainers = [ maintainers.lightbulbjim ];
  };
}
