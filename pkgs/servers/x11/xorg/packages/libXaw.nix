{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libXaw";
  version = "1.0.15";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libXaw";
    rev = "refs/tags/libXaw-1.0.15";
    hash = "sha256-kIUld4jerniESDqu+W+Xk/HSZqOG4v0XBO8maV4kmTU=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
