{
  lib,
  libedit,
  libutil,
  mkAppleDerivation,
  ncurses,
  pkg-config,
}:

mkAppleDerivation {
  releaseName = "misc_cmds";

  outputs = [
    "out"
    "man"
  ];

  xcodeHash = "sha256-xuEHBlgys/xI9lm/wtiVAKi+AWWvRluW2I4rWOmS1kw=";

  postPatch = ''
    substituteInPlace calendar/pathnames.h \
      --replace-fail '/usr' "$out"
    substituteInPlace calendar/io.c \
      --replace-fail '/usr/local' "$out"
    substituteInPlace calendar/calendar.1 \
      --replace-fail '/usr/local/share/calendar, /usr/share/calendar' "$out/share/calendar"
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libedit
    libutil
    ncurses
  ];

  meta.description = "Miscellaneous commands for Darwin";
}
