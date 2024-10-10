{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-arabic-misc";
  version = "1.0.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "arabic-misc";
    rev = "refs/tags/font-arabic-misc-1.0.4";
    hash = "sha256-LgzLOlJ0uJWvG67rR+b3stmxDwakP/KFMnzILQANERU=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
