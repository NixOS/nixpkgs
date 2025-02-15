{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-r128";
  version = "6.12.1";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-r128";
    rev = "refs/tags/xf86-video-r128-6.12.1";
    hash = "sha256-+KCgToKeJFMcLfaW5MimVKJR6J+4wVvhBv+s2wkq9fM=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
