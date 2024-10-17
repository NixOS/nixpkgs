{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xev";
  version = "1.2.5";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xev";
    rev = "refs/tags/xev-1.2.5";
    hash = "sha256-4a6QJ2uoGgUUxDb1zfwueDH8mNU/LUqcDint/4Sgdak=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
