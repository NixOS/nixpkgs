{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xsm";
  version = "1.0.5";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xsm";
    rev = "refs/tags/xsm-1.0.5";
    hash = "sha256-8gaFoQtDY9V3tgq3+hOEdxtrr6yib5Zg0arM3qjM0Q8=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
