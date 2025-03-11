{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-nouveau";
  version = "0.2.4";
  builder = ./builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-nouveau";
    rev = "3ee7cbca8f9144a3bb5be7f71ce70558f548d268";
    hash = "sha256-WmGjI/svtTngdPQgqSfxeR3Xpe02o3uB2Y9k19wqJBE=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
