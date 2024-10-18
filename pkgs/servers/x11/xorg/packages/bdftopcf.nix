{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bdftopcf";
  version = "1.1.1";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "util";
    repo = "bdftopcf";
    rev = "refs/tags/bdftopcf-1.1.1";
    hash = "sha256-85ihRH+pdpMC8RkKoU+yPlWsueF199zYyjOvSEmhCMM=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
