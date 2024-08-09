{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-glint";
  version = "1.2.9";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-glint";
    rev = "refs/tags/xf86-video-glint-1.2.9";
    hash = "sha256-Eh2lghoN+sz93LKd9LhTXPP9B637CxenDiMtpl5lHHM=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
