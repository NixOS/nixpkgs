{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-savage";
  version = "2.4.0";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-savage";
    rev = "refs/tags/xf86-video-savage-2.4.0";
    hash = "sha256-Jp7tTzB3Vi5J+T4dLpClIPmTsEErRQ+SQHeeRBFQHwc=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
