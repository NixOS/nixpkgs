{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-cirrus";
  version = "1.6.0";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-cirrus";
    rev = "refs/tags/xf86-video-cirrus-1.6.0";
    hash = "sha256-7V3czOujUIKFe9UqNX4FwpDWq9XsZeaLRu9ALnZyRMw=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
