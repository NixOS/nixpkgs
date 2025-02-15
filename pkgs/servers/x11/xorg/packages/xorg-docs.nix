{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xorg-docs";
  version = "1.7.2";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "doc";
    repo = "xorg-docs";
    rev = "refs/tags/xorg-docs-1.7.2";
    hash = "sha256-s5eNq+mLHhcG+3rhS8WXzb8gU+6B1yoVaDMEuhbIzBw=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
