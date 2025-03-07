{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bitmap";
  version = "1.1.0";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "bitmap";
    rev = "refs/tags/bitmap-1.1.0";
    hash = "sha256-hI5L4AbLoW2ecNUoKuYy9/dRgH5u1bOPiJamnZc0WFY=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
