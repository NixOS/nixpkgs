{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xcb-util-image";
  version = "0.4.1";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libxcb-image";
    rev = "refs/tags/xcb-util-image-0.4.1";
    hash = "sha256-k6+wSHKnWSkZK6gm2lYCsnTRz43OLMdO8iVRoEhtRwQ=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
