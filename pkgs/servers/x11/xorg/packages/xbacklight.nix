{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xbacklight";
  version = "1.2.3";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xbacklight";
    rev = "refs/tags/xbacklight-1.2.3";
    hash = "sha256-dDnM+eZ5eexWe/8ytOaGvev6WqdFXrxKV+zmEOPGJfY=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
