{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-sis";
  version = "0.12.0";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-sis";
    rev = "refs/tags/xf86-video-sis-0.12.0";
    hash = "sha256-C9OG/vWFIVXgRRAzn3AqE2ApABZOKT94CuIxgnOapjs=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
