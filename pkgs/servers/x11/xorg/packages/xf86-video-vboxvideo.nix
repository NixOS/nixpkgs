{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-vboxvideo";
  version = "1.0.0";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-vbox";
    rev = "refs/tags/xf86-video-vboxvideo-1.0.0";
    hash = "sha256-w8SFxFA1vUIwlPDxg3Nbd+lBAIwDBzYc3iJWrFD7nls=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
