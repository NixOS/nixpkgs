{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-bh-ttf";
  version = "1.0.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "bh-ttf";
    rev = "refs/tags/font-bh-ttf-1.0.4";
    hash = "sha256-KPFrm7NQE6VeXnk5R8hyRMw0HptVhtodDpMvvdO6+Ms=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
