{ stdenv, fetchFromGitLab, cmake, luajit,
  SDL2, SDL2_image, SDL2_ttf, physfs,
  openal, libmodplug, libvorbis, solarus,
  qtbase, qttools, fetchpatch }:

stdenv.mkDerivation rec {
  name = "solarus-quest-editor-${version}";
  version = "1.5.3";
    
  src = fetchFromGitLab {
    owner = "solarus-games";
    repo = "solarus-quest-editor";
    rev = "v1.5.3";
    sha256 = "1b9mg04yy4pnrl745hbc82rz79k0f8ci3wv7gvsm3a998q8m98si";
  };
  
  buildInputs = [ cmake luajit SDL2
    SDL2_image SDL2_ttf physfs
    openal libmodplug libvorbis
    solarus qtbase qttools ];
    
  patches = [
    ./patches/fix-install.patch

    # Next two patches should be fine to remove for next release.
    # This commit fixes issues AND adds features *sighs*
    ./patches/partial-f285beab62594f73e57190c49848c848487214cf.patch

    (fetchpatch {
      url = https://gitlab.com/solarus-games/solarus-quest-editor/commit/8f308463030c18cd4f7c8a6052028fff3b7ca35a.patch;
      sha256 = "1jq48ghhznrp47q9lq2rhh48a1z4aylyy4qaniaqyfyq3vihrchr";
    })
  ];

  meta = with stdenv.lib; {
    description = "The editor for the Zelda-like ARPG game engine, Solarus";
    longDescription = ''
      Solarus is a game engine for Zelda-like ARPG games written in lua.
      Many full-fledged games have been writen for the engine.
      Games can be created easily using the editor.
    '';
    homepage = http://www.solarus-games.org;
    license = licenses.gpl3;
    maintainers = [ maintainers.Nate-Devv ];
    platforms = platforms.linux;
  };
  
}
