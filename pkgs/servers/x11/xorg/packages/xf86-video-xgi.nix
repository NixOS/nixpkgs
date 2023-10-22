{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-xgi";
  version = "1.6.1";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-xgi";
    rev = "refs/tags/xf86-video-xgi-1.6.1";
    hash = "sha256-QLKcIWU19f1ukaf2R9Q4mMIilvRGdZuG7AJbI6HpW30=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
