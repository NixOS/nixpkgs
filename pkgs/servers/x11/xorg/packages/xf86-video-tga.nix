{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-tga";
  version = "1.2.2";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-tga";
    rev = "refs/tags/xf86-video-tga-1.2.2";
    hash = "sha256-lOm5f/VvefwfVSUwE+w+nVqMoVLeVW2XXOwqmMzFVtc=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
