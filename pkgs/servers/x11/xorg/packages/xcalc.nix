{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xcalc";
  version = "1.1.2";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xcalc";
    rev = "refs/tags/xcalc-1.1.2";
    hash = "sha256-6Fy8AShlg1PETLLAwESuRYC0evcOYeGD4A/vZnlomoc=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
