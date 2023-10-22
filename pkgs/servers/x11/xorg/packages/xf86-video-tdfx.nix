{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-tdfx";
  version = "1.5.0";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-tdfx";
    rev = "refs/tags/xf86-video-tdfx-1.5.0";
    hash = "sha256-95LFAPBT4nTuTLx83wsdOCwLOLed39WtP5FXPqiO/LI=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
