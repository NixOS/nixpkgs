{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-rendition";
  version = "4.2.7";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-rendition";
    rev = "refs/tags/xf86-video-rendition-4.2.7";
    hash = "sha256-GdQfhJTjAbADvy71IqMPHaRi/dCeMGEu6plPTxmbCLo=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
