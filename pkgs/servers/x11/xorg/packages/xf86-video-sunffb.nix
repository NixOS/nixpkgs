{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-sunffb";
  version = "1.2.3";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-sunffb";
    rev = "refs/tags/xf86-video-sunffb-1.2.3";
    hash = "sha256-wuzODH7iRBxWHzVE8v/npy1/BwS3r08GduMEDdtJd9E=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
