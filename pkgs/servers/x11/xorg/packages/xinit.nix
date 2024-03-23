{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xinit";
  version = "1.4.2";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xinit";
    rev = "refs/tags/xinit-1.4.2";
    hash = "sha256-Bw45mNCSwwP8t8LsR+pF0sRDrHdpSrNCCMBqHOt9S4A=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
