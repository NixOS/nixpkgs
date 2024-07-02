{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libXt";
  version = "1.3.0";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libXt";
    rev = "refs/tags/libXt-1.3.0";
    hash = "sha256-0kwCJPLqX0ROS/vF5sVLeQaus3oUDyGRdUIImHdsKCU=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
