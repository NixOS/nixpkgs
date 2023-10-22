{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xcursor-themes";
  version = "1.0.7";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "data";
    repo = "cursors";
    rev = "refs/tags/xcursor-themes-1.0.7";
    hash = "sha256-kcFc6ljPuVdv/oxji3Db85WvYC8zR0LQBeMtvje0tsg=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
