{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-chips";
  version = "1.4.0";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-chips";
    rev = "refs/tags/xf86-video-chips-1.4.0";
    hash = "sha256-QKHKzCqxbxoab55tYUnL4cPKpZH+3sLHjskk7LXv3ec=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
