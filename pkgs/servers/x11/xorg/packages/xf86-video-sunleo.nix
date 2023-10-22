{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-sunleo";
  version = "1.2.3";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-sunleo";
    rev = "refs/tags/xf86-video-sunleo-1.2.3";
    hash = "sha256-YAm1KpPpY+jJ+uBTxzi9bju1XNVnKy28IofP57MzQmk=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
