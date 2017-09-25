{ stdenv, fetchurl, fetchsvn, SDL, SDL_net, SDL_sound, libpng, makeDesktopItem, mesa, autoreconfHook }:

let revision = "4025";
    revisionDate = "2017-07-02";
    revisionSha = "0hbghdlvm6qibp0df35qxq35km4nza3sm301x380ghamxq2vgy6a";
in stdenv.mkDerivation rec {
  name = "dosbox-unstable-${revisionDate}";

  src = fetchsvn {
    url = "https://dosbox.svn.sourceforge.net/svnroot/dosbox/dosbox/trunk";
    rev = revision;
    sha256 = revisionSha;
  };

  hardeningDisable = [ "format" ];

  buildInputs = [ SDL SDL_net SDL_sound libpng mesa autoreconfHook ];

  desktopItem = makeDesktopItem {
    name = "dosbox";
    exec = "dosbox";
    comment = "x86 emulator with internal DOS";
    desktopName = "DOSBox (SVN)";
    genericName = "DOS emulator";
    categories = "Application;Emulator;";
  };

  postInstall = ''
     mkdir -p $out/share/applications
     cp ${desktopItem}/share/applications/* $out/share/applications
  '';

  meta = {
    homepage = http://www.dosbox.com/;
    description = "A DOS emulator";
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ binarin ];
  };
}
