{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-i128";
  version = "1.4.1";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-i128";
    rev = "refs/tags/xf86-video-i128-1.4.1";
    hash = "sha256-2yjzaJV5DIATEmByIZJXZyZ781lTUNzfafCmIlBSBRg=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
