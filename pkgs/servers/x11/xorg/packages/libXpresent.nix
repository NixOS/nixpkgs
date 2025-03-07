{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libXpresent";
  version = "1.0.1";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libXpresent";
    rev = "refs/tags/libXpresent-1.0.1";
    hash = "sha256-4cQWGRn1tcb5IA7ukLP/PObXCRl6Rf85AO6IGBAsRaQ=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
