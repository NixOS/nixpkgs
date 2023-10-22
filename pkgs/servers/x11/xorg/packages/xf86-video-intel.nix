{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-intel";
  version = "2.99.917";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-intel";
    rev = "refs/tags/xf86-video-intel-2.99.917";
    hash = "";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
