{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "makedepend";
  version = "1.0.8";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "util";
    repo = "makedepend";
    rev = "refs/tags/makedepend-1.0.8";
    hash = "sha256-cwWkMudmKgMedgca8zvwIWyNzY0/KIQBCOddMkb+8kE=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
