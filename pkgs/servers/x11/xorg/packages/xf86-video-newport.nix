{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-newport";
  version = "0.2.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-newport";
    rev = "refs/tags/xf86-video-newport-0.2.4";
    hash = "sha256-0FUJyx29vEV5qL2zXEuGPMgOiTnm51kVd2akSxYnXYY=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
