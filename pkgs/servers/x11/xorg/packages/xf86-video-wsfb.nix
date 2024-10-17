{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-wsfb";
  version = "0.4.0";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-wsfb";
    rev = "refs/tags/xf86-video-wsfb-0.4.0";
    hash = "sha256-+9HCbaX0n+cnbILhSASVrroFdRwXxAOkH27HgXkwdBo=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
