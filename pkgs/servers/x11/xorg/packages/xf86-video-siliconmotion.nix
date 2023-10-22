{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-siliconmotion";
  version = "1.7.10";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-siliconmotion";
    rev = "refs/tags/xf86-video-siliconmotion-1.7.10";
    hash = "sha256-CRuzdxlES6TFMDGIKk5sBAXF2Pa781jmTzlVT+A2Muk=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
