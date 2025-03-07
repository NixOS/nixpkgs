{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-omap";
  version = "0.4.5";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-omap";
    rev = "refs/tags/xf86-video-omap-0.4.5";
    hash = "sha256-5IffoBuSqSs0bQVCJHva/465KK0njrJyvG51dZX/rnM=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
