{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xclock";
  version = "1.1.1";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xclock";
    rev = "refs/tags/xclock-1.1.1";
    hash = "sha256-ZgUb+iVO45Az/C+2YJ1TXxcTLk3zQjM1GGv2E69WNfo=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
