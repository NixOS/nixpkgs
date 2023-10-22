{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libXext";
  version = "1.3.5";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libXext";
    rev = "refs/tags/libXext-1.3.5";
    hash = "sha256-P4IObthXMTnVYjyj0JBAcOxIqiSNaae3pzS2hCoA2rI=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
