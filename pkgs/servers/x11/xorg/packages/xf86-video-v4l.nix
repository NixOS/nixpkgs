{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-v4l";
  version = "0.3.0";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-v4l";
    rev = "refs/tags/xf86-video-v4l-0.3.0";
    hash = "sha256-uCKeecAqHycYduKaDVMupGvMN84vHeF3ECyVchkXwdA=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
