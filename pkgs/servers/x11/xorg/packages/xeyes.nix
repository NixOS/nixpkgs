{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xeyes";
  version = "1.3.0";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xeyes";
    rev = "refs/tags/xeyes-1.3.0";
    hash = "sha256-AGUaLOLDf/t5aSRzJYXa5IuA/NmtXQVv3kCbJvGHm/g=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
