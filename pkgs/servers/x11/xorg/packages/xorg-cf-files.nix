{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xorg-cf-files";
  version = "1.0.8";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "util";
    repo = "cf";
    rev = "refs/tags/xorg-cf-files-1.0.8";
    hash = "sha256-1QzSXUHNzzP7hxKrRgARd3Ia5c4sHzVXYgyOX0IbI1Y=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
