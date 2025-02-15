{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-i740";
  version = "1.4.0";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-i740";
    rev = "refs/tags/xf86-video-i740-1.4.0";
    hash = "sha256-wEpTkmzMjEebkPf6/69gjmDdJ0OQ3MrnosIXFIQor8A=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
