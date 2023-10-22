{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libXmu";
  version = "1.1.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libXmu";
    rev = "refs/tags/libXmu-1.1.4";
    hash = "sha256-PJEjFj4shj6gmjbq+5l8nooRkdQLvS6hEe4aCkjH7Dw=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
