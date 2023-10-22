{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xkbcomp";
  version = "1.4.6";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xkbcomp";
    rev = "refs/tags/xkbcomp-1.4.6";
    hash = "sha256-nas0oyiRRkGk/qXLYrjPXRPdGE7la4X3ts9Xa3m3ilA=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
