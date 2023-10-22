{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xrandr";
  version = "1.5.2";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xrandr";
    rev = "refs/tags/xrandr-1.5.2";
    hash = "sha256-YjfrnrgqEZfqBpq8vD4e/uYu7J9Ojp/9ryo0pgK1y38=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
