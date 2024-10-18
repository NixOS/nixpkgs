{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-input-joystick";
  version = "1.6.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-input-joystick";
    rev = "refs/tags/xf86-input-joystick-1.6.4";
    hash = "sha256-JxSnhWx5V3/pdlu3mwRNrgicdfaUK5nIwBK3reqchQs=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
