{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-input-keyboard";
  version = "2.0.0";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-input-keyboard";
    rev = "refs/tags/xf86-input-keyboard-2.0.0";
    hash = "sha256-ceLZ8t9Q5QQZdR+66OSdG9inlLYINq0lSCYAfTTyCho=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
