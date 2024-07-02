{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xlsclients";
  version = "1.1.5";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xlsclients";
    rev = "refs/tags/xlsclients-1.1.5";
    hash = "sha256-y1SCKQ+E9vhKaxSj08+8Lk4sWHHJnZrubOFIZg5+QiI=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
