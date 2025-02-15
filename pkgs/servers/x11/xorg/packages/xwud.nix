{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xwud";
  version = "1.0.6";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xwud";
    rev = "refs/tags/xwud-1.0.6";
    hash = "sha256-7bb9z3QjqPdVIf99sBihudQKMo5P1vjoE1HHNhGeGCI=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
