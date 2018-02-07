{ stdenv, fetchFromGitLab, SDL, SDL_image, SDL_mixer, zlib, binutils }:

stdenv.mkDerivation rec {
  name = "meritous-${version}";
  version = "1.4";

  src = fetchFromGitLab {
    owner = "meritous";
    repo = "meritous";
    rev = "314af46d84d2746eec4c30a0f63cbc2e651d5303";
    sha256 = "1hrwm65isg5nwzydyd8gvgl3p36sbj09rsn228sppr8g5p9sm10x";
  };

  prePatch = ''
    substituteInPlace Makefile \
      --replace "CPPFLAGS +=" "CPPFLAGS += -DSAVES_IN_HOME -DDATADIR=\\\"$out/share/meritous\\\"" \
      --replace sld-config ${SDL.dev}/bin/sdl-config
    substituteInPlace src/audio.c \
      --replace "filename[64]" "filename[256]"
  '';

  buildInputs = [ SDL SDL_image SDL_mixer zlib ];

  installPhase = ''
    install -m 555 -D meritous $out/bin/meritous
    mkdir -p $out/share/meritous
    cp -r dat/* $out/share/meritous/
  '';

  hardeningDisable = [ "stackprotector" "fortify" ];

  meta = with stdenv.lib; {
    description = "Action-adventure dungeon crawl game";
    homepage = http://www.asceai.net/meritous/;
    license = licenses.gpl3;
    maintainers = [ maintainers.alexvorobiev ];
    platforms = platforms.linux;
  };
}

