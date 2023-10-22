{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-glide";
  version = "1.2.2";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-glide";
    rev = "refs/tags/xf86-video-glide-1.2.2";
    hash = "sha256-HsGBOSDlmgFscUh/Z051QIS0wVc2NNHucMOHhCYguQg=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
