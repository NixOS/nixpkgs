{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xtrans";
  version = "1.5.0";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libxtrans";
    rev = "refs/tags/xtrans-1.5.0";
    hash = "sha256-bjcOr5+WD87XvOwrMDTmnZ+aGxL1SVtxXlU1VBjqzqA=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
