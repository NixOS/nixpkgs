{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfd";
  version = "1.1.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xfd";
    rev = "refs/tags/xfd-1.1.4";
    hash = "sha256-8kkoJILNlVgDIV029mF3err6es5V001FQqUnTtD9/LQ=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
