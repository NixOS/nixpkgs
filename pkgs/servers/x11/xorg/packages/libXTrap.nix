{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libXTrap";
  version = "1.0.1";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libXTrap";
    rev = "refs/tags/libXTrap-1.0.1";
    hash = "sha256-tA85WfgjooLxNmHJ4/X0lKOBuPgGLGquRoKouaKxlf4=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
