{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xcb-util-errors";
  version = "1.0.1";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libxcb-errors";
    rev = "refs/tags/xcb-util-errors-1.0.1";
    hash = "sha256-HbfjryhbiGJGkzN0k5GIAjc1uABXWBYyaXIjIqT+cwE=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
