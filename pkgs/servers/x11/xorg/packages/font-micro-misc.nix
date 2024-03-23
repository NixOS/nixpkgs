{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-micro-misc";
  version = "1.0.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "micro-misc";
    rev = "refs/tags/font-micro-misc-1.0.4";
    hash = "sha256-D9g9jfbDnyBNZ0aPETd9pmQokOTGGJBM7ljjI7dIzQ4=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
