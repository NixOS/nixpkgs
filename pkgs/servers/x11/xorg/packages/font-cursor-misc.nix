{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-cursor-misc";
  version = "1.0.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "cursor-misc";
    rev = "refs/tags/font-cursor-misc-1.0.4";
    hash = "sha256-zLUH6UqPSJ2rF5wjNF6tg6ltAscF+eVbr7Ty8m2itaI=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
