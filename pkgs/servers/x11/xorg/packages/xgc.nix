{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xgc";
  version = "1.0.6";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xgc";
    rev = "refs/tags/xgc-1.0.6";
    hash = "sha256-SJk5CL3TT7aNlx8JriNAbhY161TAaiPRebBCWpWPD/0=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
