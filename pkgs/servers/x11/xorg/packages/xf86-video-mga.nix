{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-mga";
  version = "2.0.1";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-mga";
    rev = "refs/tags/xf86-video-mga-2.0.1";
    hash = "sha256-csHUhTLnfRFynxuXzB+Hk8UlD5AX1NOxwN8ONvqodpM=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
