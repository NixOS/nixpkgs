{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-trident";
  version = "1.4.0";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-trident";
    rev = "refs/tags/xf86-video-trident-1.4.0";
    hash = "sha256-xTBktn813s8Dy3gPScEHVlWMzSRx7oIymbFUpkvYAhE=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
