{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-fbdev";
  version = "0.5.0";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-fbdev";
    rev = "refs/tags/xf86-video-fbdev-0.5.0";
    hash = "sha256-xIB5D8c7pp5GuYlY68qYGVQ3yCZMpXFx2h0Czbphxr4=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
