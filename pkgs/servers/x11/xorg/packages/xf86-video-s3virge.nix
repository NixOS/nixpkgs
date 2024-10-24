{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-s3virge";
  version = "1.11.1";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-s3virge";
    rev = "refs/tags/xf86-video-s3virge-1.11.1";
    hash = "sha256-UxAzsevKIMA3p6Q5cKjRPOku4cfbXiLmcJQWNEjpu7s=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
