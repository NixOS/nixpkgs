{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-vesa";
  version = "2.6.0";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-vesa";
    rev = "refs/tags/xf86-video-vesa-2.6.0";
    hash = "sha256-M8/mSgD398wBswOp0oEXvlcgVsYdWcTIw3ah5e1uHV8=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
