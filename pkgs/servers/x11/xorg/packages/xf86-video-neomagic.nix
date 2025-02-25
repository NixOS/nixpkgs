{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-neomagic";
  version = "1.3.1";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-neomagic";
    rev = "refs/tags/xf86-video-neomagic-1.3.1";
    hash = "sha256-j1zhKGYmKADZ/6WuCQTca7l+rTgqlLhGoQvYhWxWAAE=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
