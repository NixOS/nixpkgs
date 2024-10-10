{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "viewres";
  version = "1.0.7";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "viewres";
    rev = "refs/tags/viewres-1.0.7";
    hash = "sha256-HYjLtFD+wvsx5dj5U2WDl9IUTrnPrKiFqZFEbB3DTgM=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
