{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xset";
  version = "1.2.5";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xset";
    rev = "refs/tags/xset-1.2.5";
    hash = "sha256-fPdaBwmZNeAxXrKjJkjOlxSwBhmPlAXl+Z7luwwwdV0=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
