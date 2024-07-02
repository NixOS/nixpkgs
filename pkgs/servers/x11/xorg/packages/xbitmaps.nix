{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xbitmaps";
  version = "1.1.3";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "data";
    repo = "bitmaps";
    rev = "refs/tags/xbitmaps-1.1.3";
    hash = "sha256-lBtOiI/KmnJI2Y1yGT1QQPebcCDUYanw2QMfjfnijIU=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
