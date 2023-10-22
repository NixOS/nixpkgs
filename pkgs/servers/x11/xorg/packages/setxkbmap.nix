{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "setxkbmap";
  version = "1.3.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "setxkbmap";
    rev = "refs/tags/setxkbmap-1.3.4";
    hash = "sha256-eEh1rifV+XY5RuKbA3Rgn9vmQPnyWvSae/m5lZA3FGE=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
