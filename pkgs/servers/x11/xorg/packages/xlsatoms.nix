{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xlsatoms";
  version = "1.1.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xlsatoms";
    rev = "refs/tags/xlsatoms-1.1.4";
    hash = "sha256-R8X4dxVfKyRSIt7npPD9FUi/M4yR4l9JzoXsuoULiag=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
