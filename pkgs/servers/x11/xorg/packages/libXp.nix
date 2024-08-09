{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libXp";
  version = "1.0.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libXp";
    rev = "refs/tags/libXp-1.0.4";
    hash = "sha256-MXqed2A8Wn+Fcpv+31e5F6uq2lkEgId/MnbP3CXWa/0=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
