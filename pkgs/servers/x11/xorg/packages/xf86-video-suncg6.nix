{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-suncg6";
  version = "1.1.3";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-suncg6";
    rev = "refs/tags/xf86-video-suncg6-1.1.3";
    hash = "sha256-M9O0BNrKAFdiEgpZstH8KHRVIMEy5dI3y8rP+MSzLCY=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
