{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-geode";
  version = "2.11.21";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-geode";
    rev = "refs/tags/xf86-video-geode-2.11.21";
    hash = "sha256-0z3mJUSPpCa00LmWMaljwgoLrRoOLvq+xzYcAAUwsDM=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
