{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdriinfo";
  version = "1.0.7";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xdriinfo";
    rev = "refs/tags/xdriinfo-1.0.7";
    hash = "sha256-yP2u6lvZOqvxJYVkunENG8fkLA1wSbz+kKyeoO932zQ=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
