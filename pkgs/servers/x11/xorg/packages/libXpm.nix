{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libXpm";
  version = "3.5.17";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libXpm";
    rev = "refs/tags/libXpm-3.5.17";
    hash = "sha256-vOhNhbomJ4Oyg/1fb+MSg64Z4G2TQ/PJDvUgJFHuGgs=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
