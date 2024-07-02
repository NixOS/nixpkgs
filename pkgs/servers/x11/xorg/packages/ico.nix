{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ico";
  version = "1.0.6";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "ico";
    rev = "refs/tags/ico-1.0.6";
    hash = "sha256-398xyTgJfh3STq2qpXxhxr/PewAVpYPSA1RCbYygwDI=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
