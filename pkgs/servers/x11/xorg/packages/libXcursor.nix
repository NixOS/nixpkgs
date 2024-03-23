{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libXcursor";
  version = "1.2.1";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libXcursor";
    rev = "refs/tags/libXcursor-1.2.1";
    hash = "sha256-E5p2h+f19Evqxmobuma/jC9QU5U5VhJLJQmCMrOcFy0=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
