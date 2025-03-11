{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "transset";
  version = "1.0.3";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "transset";
    rev = "refs/tags/transset-1.0.3";
    hash = "sha256-XoeatejA7p5xQNrIlgC+1AUBaBmQU3Fe5oSTCgTv/Xo=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
