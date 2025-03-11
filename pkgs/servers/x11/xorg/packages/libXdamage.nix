{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libXdamage";
  version = "1.1.6";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libXdamage";
    rev = "refs/tags/libXdamage-1.1.6";
    hash = "sha256-VcoOkWL+RKxLoQT6hAXR5kPG8rlJKOdrkKGrP9JRFh4=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
